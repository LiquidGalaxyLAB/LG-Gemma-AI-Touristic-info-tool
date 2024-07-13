

from helpers import *

set_debug(True)
set_verbose(True)

# Define your Pydantic models
class Place(BaseModel):
    name: str = Field(description="Full name of the place",default=None)
    address: str = Field(description="Address of the place",default=None)
    city: str = Field(description="Name of the city", default=None)
    country: str = Field(description="Name of the country", default=None)
    description: str = Field(description="A brief description", default=None)
    ratings: float = Field(description="Average rating", default=None) 
    amenities: str = Field(description="Amenities available", default=None)
    price: str = Field(description="Pricing info", default=None) 
    source: str= Field(description="Source link of the retrieved information ", default=None) 

class Places(BaseModel):
    places: List[Place] = Field(description="List of Place dictionaries",default=None)

parser = PydanticOutputParser(pydantic_object=Places)


# Initialize embeddings and LLM
llm = Ollama(model="gemma2:9b-instruct-q4_K_M", num_ctx=8192)
#temperature=1.2, repeat_penalty=1.8
embeddings = OllamaEmbeddings(model='nomic-embed-text:v1.5', num_ctx=8192, show_progress=True)

# Web scraping function
def scrape_urls(user_query):
    words = user_query.split()
    url_search = '+'.join(words)
    seed_url = f'https://www.google.com/search?q={url_search}'

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
        "Accept-Language": "en-US,en;q=0.5",
        "Referer": "https://www.google.com/",
    }

    response = requests.get(seed_url, headers=headers)
    general_fetched_urls = []

    if response.status_code == 200:
        page_content = response.text
        sp = soup(page_content, 'html.parser')
        for a_tag in sp.find_all('a', href=True):
            link = a_tag['href']
            if 'url=' in link and '&ved=' in link:
                url_part = link.split('url=')[1]
                url = url_part.split('&ved=')[0]
                decoded_url = urllib.parse.unquote(url)
                if decoded_url.startswith('https://') and 'tripadvisor' not in decoded_url:
                    try:
                        r = requests.get(decoded_url, headers=headers, verify=True, timeout=20)
                        if r.status_code == 200 or r.status_code == 520:
                            general_fetched_urls.append(decoded_url)
                            if len(general_fetched_urls) >= 10:
                                break
                    except requests.exceptions.SSLError:
                        print(f"SSL Error for URL: {link}")
                    except requests.exceptions.RequestException as e:
                        print(f"Request Exception for URL: {link}, Error: {e}")

    return general_fetched_urls


app = FastAPI(
    title="LangChain Server",
    version="1.0",
    description="Spin up a simple api server using Langchain's Runnable interfaces",
)

    
# Define the LangServe handler
async def handle_request(user_query:str):
        
        general_fetched_urls = scrape_urls(user_query)

        # Load Data
        loader = AsyncChromiumLoader(general_fetched_urls, user_agent="MyAppUserAgent")
        docs = await loader.aload()

        html2text = Html2TextTransformer()
        docs_transformed = html2text.transform_documents(docs, kwargs={"parse_only": bs4.SoupStrainer(class_=("post-title", "post-header", "post-content"))})

        # Filter out non-English documents
        def is_english(text):
            try:
                return detect(text) == 'en'
            except:
                return False

        docs_transformed_english = [doc for doc in docs_transformed if is_english(doc.page_content)]

        # Split documents
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        splits = text_splitter.split_documents(docs_transformed_english)

        # Store embeddings into vectorstore
        vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
        retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

        # Prompt template
        prompt_template='''
        You are an advanced AI model acting as a touristic guide with extensive knowledge of various travel destinations and touristic information. 
        Use your internal knowledge and the provided context to generate a comprehensive and accurate response.
        Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
        Your answer must include the accurate address of each of the 10 places too.
        Your answer must include the country.
        Your answer must include addtional information such as: pricing, rating, and amenities.
        If any of the information is not available to you, leave empty.
        Do not include null in your response. 
        Do not omit any place from the list for brevity. 
        Your answer MUST include all 10 places.
        Make sure to include a "source" key with the URL from which the information for each place was retrieved.
        Your answer must be in a Well-defined JSON format, with correct curly braces, commas, and quotes. Only user double quotes for strings in your JSON format.
        Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string), source (string). 
        If a string is empty, do not write null, just leave it as an empty string.
        If a float is empty, write it as 0.0
        The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.
        The response should not be enclosed in a code section.


        CONTEXT:
        {context}

        QUESTION: {question}

        YOUR ANSWER:"""
        '''

        prompt = PromptTemplate(
            template=prompt_template,
            input_variables=["question",],
        )

        rag_chain = (
            {"context": retriever, "question": RunnablePassthrough()}
            | prompt
            | llm
            | parser
        )
        # result = await rag_chain.invoke({"question": user_query})
        # parsed_result = parser.parse(result)
        # return parsed_result

        return rag_chain
        # for chunk in rag_chain.stream({"question": user_query}):
        #     print(chunk)

        #return rag_chain.stream("question " "Theme Parks World Wide")
        #return rag_chain

        # #result = await rag_chain.astream({"question": user_query})
        # result = []
        # async for item in rag_chain.astream({"question": user_query}):
        #     yield item  # Stream the item
        #     result.append(item)  # Collect the item
        #     print(item)
            
        # Return the collected results after streaming

        #vectorstore.delete_collection()
        #return result
        
        #result = rag_chain.invoke({"question": user_query})
        #parsed_result = parser.parse(result)

        
        #yield result
        #return parsed_result



    
# Define the LangServe handler
def parse_result(unparsed_res:str):

        # Prompt template
        prompt_template='''
        You are an advanced AI model that formats any unformatted string input into a well-structured JSON format.
        Your answer must be in a Well-defined JSON format, with correct curly braces, commas, and quotes. Only user double quotes for strings in your JSON format.
        Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string), source (string). 
        The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.

        INPUT: {input}

        YOUR ANSWER:"""
        '''

        prompt = PromptTemplate(
            template=prompt_template,
            input_variables=["input",],
        )

        rag_chain = (
            {"input": RunnablePassthrough()}
            | prompt
            | llm
        
        )
        result = rag_chain.invoke({"input": unparsed_res})
        parsed_result = parser.parse(result)
        return parsed_result
        



# @app.post("/rag/invoke")
# async def simple_invoke(query: Query):
#     try:
#         result = handle_request(query.user_query)
#         return result
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=str(e))
    


chain = RunnableLambda(handle_request)

parse_chain= RunnableLambda(parse_result)

add_routes(app,
           runnable= chain, 
           path="/rag", 
           enable_feedback_endpoint=True,
            enable_public_trace_link_endpoint=True,
            playground_type="default"
        )

add_routes(app,
           runnable= parse_chain, 
           path="/parse", 
           enable_feedback_endpoint=True,
            enable_public_trace_link_endpoint=True,
            playground_type="default"
        )


# data= {"output":"{\n\"places\": [\n    {\n      \"name\": \"Walt Disney World's Magic Kingdom\",\n      \"address\": \"1180 Seven Seas Dr, Lake Buena Vista, FL 32830\",\n      \"city\": \"Lake Buena Vista\",\n      \"country\": \"United States\",\n      \"description\": \"The most magical place on Earth, featuring classic attractions, parades, fireworks, and beloved Disney characters.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.8,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Disneyland\",\n      \"address\": \"1313 Disneyland Dr, Anaheim, CA 92803\",\n      \"city\": \"Anaheim\",\n      \"country\": \"United States\",\n      \"description\": \"The original Disney theme park, with classic attractions, charming lands, and a nostalgic atmosphere.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.7,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Universal Studios Japan\",\n      \"address\": \"2 Chome-1-33 Sakurajima, Osaka, 554-0031, Japan\",\n      \"city\": \"Osaka\",\n      \"country\": \"Japan\",\n      \"description\": \"A world-class theme park featuring thrilling rides based on popular movies and TV shows, as well as Japanese culture attractions.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.6,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Tokyo Disneyland\",\n      \"address\": \"1-1-83, Maihama, Urayasu, Chiba 279-0031, Japan\",\n      \"city\": \"Urayasu\",\n      \"country\": \"Japan\",\n      \"description\": \"A classic Disney theme park with beloved attractions, parades, and shows, set in a beautiful Japanese garden.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.9,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Universal's Islands of Adventure\",\n      \"address\": \"6000 Universal Blvd, Orlando, FL 32819\",\n      \"city\": \"Orlando\",\n      \"country\": \"United States\",\n      \"description\": \"A thrilling theme park with immersive lands based on popular movies and books, featuring record-breaking roller coasters.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.7,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Disney's Hollywood Studios\",\n      \"address\": \"1313 Disneyland Dr, Anaheim, CA 92803\",\n      \"city\": \"Anaheim\",\n      \"country\": \"United States\",\n      \"description\": \"A movie-themed park with thrilling rides, live shows, and immersive experiences, celebrating the magic of Hollywood.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.6,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Universal Studios Florida\",\n      \"address\": \"6000 Universal Blvd, Orlando, FL 32819\",\n      \"city\": \"Orlando\",\n      \"country\": \"United States\",\n      \"description\": \"A movie-themed park with thrilling rides, live shows, and immersive experiences, celebrating the magic of Hollywood.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.5,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Tokyo DisneySea\",\n      \"address\": \"1-1-83, Maihama, Urayasu, Chiba 279-0031, Japan\",\n      \"city\": \"Urayasu\",\n      \"country\": \"Japan\",\n      \"description\": \"A unique Disney park with nautical themes, thrilling rides, and stunning views, offering a truly immersive experience.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.8,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"EPCOT\",\n      \"address\": \"200 Epcot Dr, Lake Buena Vista, FL 32830\",\n      \"city\": \"Lake Buena Vista\",\n      \"country\": \"United States\",\n      \"description\": \"A park celebrating world cultures and technological advancements, featuring innovative attractions, international cuisine, and educational exhibits.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.6,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    },\n    {\n      \"name\": \"Disneyland Paris\",\n      \"address\": \"Boulevard de la Marne, 77700 Marne-la-Vallée, France\",\n      \"city\": \"Marne-la-Vallée\",\n      \"country\": \"France\",\n      \"description\": \"A European Disney park with charming lands, classic attractions, and a unique blend of French and American culture.\",\n      \"pricing\": \"Prices vary by ticket type and date.\",\n      \"rating\": 4.5,\n      \"amenities\": \"Restaurants, shops, hotels, transportation.\",\n      \"source\": \"https://www.themeparkinsider.com/reviews/\"\n    }\n  ]\n} \n"}
# data_json= json.loads(data)

# api_handler = APIHandler(chain, path="/rag")

# # First register the endpoints without documentation
# @app.post("/rag/invoke", include_in_schema=False)
# async def simple_invoke(request: Request) -> Response:
#     """Handle a request."""
#     # The API Handler validates the parts of the request
#     # that are used by the runnnable (e.g., input, config fields)
#     return await api_handler.invoke(request)


# async def _get_api_handler() -> APIHandler:
#     """Prepare a RunnableLambda."""
#     return APIHandler(RunnableLambda(handle_request), path="/rag")


# @app.post("/rag/astream")
# async def rag_astream(
#     request: Request, runnable: Annotated[APIHandler, Depends(_get_api_handler)]
# ) -> EventSourceResponse:
#     """Handle astream request."""
#     # The API Handler validates the parts of the request
#     # that are used by the runnnable (e.g., input, config fields)
#             # async for item in rag_chain.astream({"question": user_query}):
#         #     yield item  # Stream the item
#         #     result.append(item)  # Collect the item
#         #     print(item)
#     # async for item in runnable.astream_events(request):
#     #     yield item
#     #     print(item)
#     return await runnable.astream_events(request)


# @app.post("/rag/streamlog")
# async def rag_stream_log(
#     request: Request, runnable: Annotated[APIHandler, Depends(_get_api_handler)]
# ) -> EventSourceResponse:
#     """Handle stream log request."""
#     # The API Handler validates the parts of the request
#     # that are used by the runnnable (e.g., input, config fields)
#     return await runnable.stream_log(request)


@app.get("/health")
async def health_check():
    return JSONResponse(status_code=200, content={"status": "OK"})

@app.get("/search")
async def fetch_urls(user_query:str):
    general_urls= scrape_urls(user_query)
    return general_urls

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=3000)

