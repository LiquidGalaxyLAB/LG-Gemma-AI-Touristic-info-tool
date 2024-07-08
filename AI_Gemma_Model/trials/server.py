

from helpers import *



# Define your Pydantic models
class Place(BaseModel):
    name: str = Field(description="Full name of the place", default=None)
    address: str = Field(description="Address of the place", default=None)
    city: str = Field(description="Name of the city", default=None)
    country: str = Field(description="Name of the country", default=None)
    description: str = Field(description="A brief description", default=None)
    ratings: float = Field(description="Average rating", default=None) 
    amenities: str = Field(description="Amenities available", default=None)
    price: str = Field(description="Pricing info", default=None) 
    source: str= Field(description="Source link of the retrieved information ", default=None) 

class Places(BaseModel):
    places: List[Place] = Field(description="List of Place dictionaries", default=None)

parser = PydanticOutputParser(pydantic_object=Places)


# Initialize embeddings and LLM
llm = Ollama(model="gemma2:9b", num_ctx=8192)
embeddings = OllamaEmbeddings(model='nomic-embed-text', num_ctx=8192, show_progress=True)

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
        docs = loader.load()

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
        Your answer must include addtional information such as: pricing, rating, and amenities.
        If any of the information is not available to you, leave empty.
        Do not omit any place from the list for brevity. 
        Your answer MUST include all 10 places.
        Make sure to include a "source" key with the URL from which the information for each place was retrieved.
        Your answer must be in a Well-defined JSON format, with correct curly braces, commas, and quotes. Only user double quotes for strings in your JSON format.
        Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string), source (string). 
        The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.


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
        

        #result = rag_chain.invoke({"question": user_query})
        result = await rag_chain.astream({"question": user_query})
        # parsed_result = parser.parse(result)

        vectorstore.delete_collection()
       # return parsed_result
        yield result


# @app.post("/rag/invoke")
# async def simple_invoke(query: Query):
#     try:
#         result = handle_request(query.user_query)
#         return result
#     except Exception as e:
#         raise HTTPException(status_code=400, detail=str(e))
    

chain = RunnableLambda(handle_request)

add_routes(app,
           runnable= chain, 
           path="/rag", 
           enable_feedback_endpoint=True,
            enable_public_trace_link_endpoint=True,
            playground_type="default"
            )

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
#     return await runnable.astream_events(request)


# @app.post("/rag/streamlog")
# async def rag_stream_log(
#     request: Request, runnable: Annotated[APIHandler, Depends(_get_api_handler)]
# ) -> EventSourceResponse:
#     """Handle stream log request."""
#     # The API Handler validates the parts of the request
#     # that are used by the runnnable (e.g., input, config fields)
#     return await runnable.stream_log(request)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000)
