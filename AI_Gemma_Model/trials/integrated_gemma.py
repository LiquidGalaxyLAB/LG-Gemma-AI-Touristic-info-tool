from helpers import *

set_debug(True)
set_verbose(True)



#######################################  Defining parser & Schema  ######################################################

class Place(BaseModel):
    name: str = Field(description="Full name of the place", default=None)
    address: str = Field(description="Address of the place", default=None)
    city: str = Field(description="Name of the city", default=None)
    country: str = Field(description="Name of the country", default=None)
    description: str = Field(description="A brief description", default=None)
    ratings: float = Field(description="Average rating", default=None) 
    amenities: str = Field(description="Amenities available", default=None)
    price: str = Field(description="Pricing info", default=None) 

class Places(BaseModel):
    places: List[Place] = Field(description="List of Place dictionaries", default=None)

parser = PydanticOutputParser(pydantic_object=Places)

####################################### Start Time ######################################################

start_time = time.time()

#######################################  Embeddings & Model  ######################################################

llm = Ollama(model="gemma:7b", num_ctx=8192)# default is 2048
embeddings= (OllamaEmbeddings(model='nomic-embed-text',num_ctx=8192, show_progress=True))   #8192 context windo like gemma 7b/2b context window


####################################### User Query  ######################################################


user_query="Cycling Tours Worldwide"
question= f'{user_query}'

####################################### Web scraping ######################################################

words = user_query.split()
url_search = '+'.join(words)
print(url_search)


seed_url=f'https://www.google.com/search?q={url_search}'

print('seed_url:',seed_url)


general_fetched_urls=[]


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer": "https://www.google.com/",
}

response = requests.get(seed_url, headers=headers)
if response.status_code == 200:
    page_content = response.text
    
    sp = soup(page_content, 'html.parser')
    
    for a_tag in sp.find_all('a', href=True):
        link = a_tag['href']

        if 'url=' in link and '&ved=' in link:
            url_part = link.split('url=')[1]
            url = url_part.split('&ved=')[0]
            decoded_url = urllib.parse.unquote(url)
            
            # Ensure the URL starts with 'https://'
            if decoded_url.startswith('https://') and 'tripadvisor' not in decoded_url:
                try:
                    r = requests.get(decoded_url, headers=headers, verify=True, timeout=20)
                    # print(r.status_code)
                    if r.status_code == 200 or r.status_code == 520:
                            url_with_language = f"{decoded_url}&hl=en"
                            general_fetched_urls.append(url_with_language)
                            if len(general_fetched_urls) >= 10:
                                break
                except requests.exceptions.SSLError:
                    print(f"SSL Error for URL: {link}")
                except requests.exceptions.RequestException as e:
                    print(f"Request Exception for URL: {link}, Error: {e}")



# Display the scraped URLs
print('General fetched Urls:')
print(general_fetched_urls)

print("---------------------------------")


####################################### Load Data ######################################################

# Only keep post title, headers, and content from the full HTML.
bs4_strainer = bs4.SoupStrainer(class_=("post-title", "post-header", "post-content"))
loader = AsyncChromiumLoader(general_fetched_urls, user_agent="MyAppUserAgent")
docs = loader.load()
print(len(docs))


html2text = Html2TextTransformer()
translator = Translator()

## Function to detect language and filter non-English documents
def is_english(text):
    try:
        return detect(text) == 'en'
    except:
        return False


docs_transformed = html2text.transform_documents(docs, kwargs={"parse_only": bs4_strainer},)
docs_transformed[0].page_content[0:500]
print(f'docs_transformed 0:{docs_transformed[0]}')

# Filter out non-English documents
docs_transformed_english = [doc for doc in docs_transformed if is_english(doc.page_content)]
print(len(docs_transformed_english))
print(f'docs_transformed EN 0:{docs_transformed_english[0]}')


####################################### Splitting ######################################################

text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs_transformed_english)


################################ Store Embeddings into VectorStore #########################################

vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
print('vectorestore initialized')


####################################### Retrivers ######################################################

retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
print('retriever initialized')
print(retriever)


####################################### Prompt ######################################################

prompt_template='''
You are an advanced AI model acting as a touristic guide with extensive knowledge of various travel destinations and touristic information. 
Use your internal knowledge and the provided context to generate a comprehensive and accurate response.
Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
Your answer must include the accurate address of each of the 10 places too.
Your answer must include addtional information such as: pricing, rating, and amenities.
If any of the information is not available to you, leave empty.
Do not omit any place from the list for brevity. 
Your answer MUST include all 10 places.
Your answer must be in a Well-defined JSON format, with correct curly braces, commas, and quotes. Only user double quotes for strings in your JSON format.
Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string). 
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



####################################### Chaining ######################################################

rag_chain = (
    {"context": retriever , "question": RunnablePassthrough()}
    | prompt
    | llm
)

####################################### Running GEMMA ######################################################

result=rag_chain.invoke({"question": user_query})

print('result:')
print(result)

print('type of result:')
print(type(result))


####################################### Parsing Output ######################################################

parsed_result= parser.parse(result)

print('parsed result:')
print(parsed_result)

####################################### End Time ######################################################

end_time=time.time()
print("Time taken: ", end_time-start_time)


####################################### Clean Up ######################################################

vectorstore.delete_collection()

############################################# Langserve ######################################

# # Define the LangServe app
# app = LangServeApp()

# class TouristGuideHandler(LangServeHandler):
#     def handle_request(self, request):
#         user_query = request["query"]
#         result = rag_chain.invoke({"question": user_query})
#         return result

# # Add the handler to the app
# app.add_handler(TouristGuideHandler, "/guide")

# if __name__ == "__main__":
#     app.run()



# app = FastAPI(
#     title="LangChain Server",
#     version="1.0",
#     description="A simple api server using Langchain's Runnable interfaces",
# )

# add_routes(
#     app,
#     rag_chain,
#     path="/ragChain",
# )


# uvicorn.run(app, host="localhost", port=8000)


####################################### Drafts ######################################################

# Things to be done: 

# Stream the output
# Get sources