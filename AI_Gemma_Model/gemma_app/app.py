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
    general_fetched_urls=[]
    try:
        from googlesearch import search
    except ImportError: 
        print("No module named 'google' found")
    
    for url in search(user_query,num_results=10, ssl_verify=True, safe="active", lang="en"):
        if('tripadvisor' not in url):
            general_fetched_urls.append(url)
            print(url)
            if len(general_fetched_urls) >= 10:
               print('Fetched 10 URLs')
               break
    return general_fetched_urls


app = FastAPI(
    title="LangChain Server",
    version="1.0",
    description="Spin up a simple api server using Langchain's Runnable interfaces",
)

    
# Define the LangServe handler
async def handle_request(user_query:str):
        
        general_fetched_urls = scrape_urls(user_query)
        # general_fetched_urls=[]

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
            input_variables=["question"],
        )

        rag_chain = (
            {"context": retriever, "question": RunnablePassthrough()}
            | prompt
            | llm
            | parser
        )


        return rag_chain



chain = RunnableLambda(handle_request)


add_routes(app,
           runnable= chain, 
           path="/rag", 
           enable_feedback_endpoint=True,
            enable_public_trace_link_endpoint=True,
            playground_type="default"
        )


@app.get("/health")
async def health_check():
    return JSONResponse(status_code=200, content={"status": "OK"})


@app.get("/search")
async def fetch_urls(place_name: str):
    try:
        general_fetched_urls = scrape_urls(place_name)
        return general_fetched_urls
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

    

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8085)

