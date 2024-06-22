
from helpers import *

set_debug(True)
set_verbose(True)

response_schemas = [
    ResponseSchema(name="countryName", description="Name of the country"),
    # ResponseSchema(name="Cities", description="List of available cities in the country", type="array(string)"),
    ResponseSchema(
    name="PlacesList", description="List of 10 places with their details following this example: [{placeName: string, address: [string], city: string, description: string, ratings: float, amenities: [string], prices: string}]", 
    type="array(objects)"
    )
]


embeddings= (OllamaEmbeddings(model='nomic-embed-text',num_ctx=8192, temperature=1.2, show_progress=True, repeat_penalty=1.8, repeat_last_n=-1))   #8192 context windo like gemma 7b/2b context window
llm = Ollama(model="gemma:7b", num_ctx=8192, temperature=1.2, verbose=True,repeat_penalty=1.8, repeat_last_n=-1)

user_query="best activities to do in Egypt's desert"

# question_template_p1='Please, Can you help me find the Top 10 places for'
# question_template_p2='and include all details you know about them such as name, address locations, description and more!'
# question= f'{question_template_p1} {user_query} {question_template_p2}'
question= f'{user_query}'

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

start_time = time.time()

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


text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs_transformed_english)
# splits = text_splitter.split_documents(docs_transformed)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
print('vectorestore initialized')

retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
print('retriever initialized')
print(retriever)



output_parser = StructuredOutputParser.from_response_schemas(response_schemas)
format_instructions = output_parser.get_format_instructions()




prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Use the provided context as the basis for your answers and do not make up new reasoning paths - just mix-and-match what you are given.
Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
Your answer must include the accurate address of each of the 10 places too.
Your answer must include addtional information such as: pricing, rating, and amenities.
If any of the information is not available to you, leave empty.

{format_instructions}

CONTEXT:
{context}

QUESTION: {question}

YOUR ANSWER:"""
'''

prompt= PromptTemplate(
    template=prompt_template, 
    input_variables=["question"], 
    partial_variables={"format_instructions": format_instructions}
    )



rag_chain = (
    {"context": retriever , "question": RunnablePassthrough()}
    | prompt
    | llm
    | output_parser
)



print('Asking the model:')

llm_results= rag_chain.invoke(question)
# llm_results = rag_chain.invoke(input=input_data)
print(llm_results)

elapsed_time = time.time() - start_time
print(f"Execution time: {elapsed_time:.2f} seconds")


# cleanup
vectorstore.delete_collection()


