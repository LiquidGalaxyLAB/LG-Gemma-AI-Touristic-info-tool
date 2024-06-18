
import os
import dotenv , getpass

dotenv.load_dotenv()

# os.environ["LANGCHAIN_TRACING_V2"] = "true"
# os.environ["LANGCHAIN_API_KEY"] = getpass.getpass()


import bs4
from langchain import hub
from langchain_community.document_loaders import WebBaseLoader
from langchain_chroma import Chroma
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.llms import Ollama
from langchain_community.embeddings import OllamaEmbeddings
from langchain_core.prompts import PromptTemplate
import time
import requests
from bs4 import BeautifulSoup as soup
import urllib.parse
from langchain_community.document_loaders import AsyncChromiumLoader
from langchain_community.document_transformers import Html2TextTransformer

embeddings = (
    OllamaEmbeddings(model="all-minilm")
)  
llm = Ollama(model="gemma:7b")


question="Best pizza places in Cairo Egypt"

words = question.split()
url_search = '+'.join(words)
print(url_search)

seed_url=f'https://www.google.com/search?q={url_search}'
google_maps_url=f'https://www.google.com/maps/search/{url_search}'
print('seed_url:',seed_url)
print('google_maps_url:',google_maps_url)


general_fetched_urls=[]
all_fetched_urls=[]


headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

response = requests.get(seed_url, headers=headers)
if response.status_code == 200:
    page_content = response.text
    
    # Parse HTML content
    sp = soup(page_content, 'html.parser')
    
    # Find all <a> tags and extract URLs
     # Find all <a> tags and extract URLs
    for a_tag in sp.find_all('a', href=True):
        link = a_tag['href']

        # Check if the link contains 'url=' and '&ved'
        if 'url=' in link and '&ved=' in link:
            # Extract the part after 'url='
            url_part = link.split('url=')[1]
            # Find the position of '&ved=' and slice the URL up to that position
            url = url_part.split('&ved=')[0]
            # Decode the URL to handle any URL encoding
            decoded_url = urllib.parse.unquote(url)
            
            # Ensure the URL starts with 'https://'
            if decoded_url.startswith('https://'):
                # scraped_urls.append(decoded_url)
                try:
                    # Try to make a request to the URL to check for SSL certificate validity
                    r = requests.get(decoded_url, headers=headers, verify=True, timeout=20)
                    # If the request is successful and no SSL errors are raised, add the URL to the list
                    # print(r.status_code)
                    if r.status_code == 200 or r.status_code == 520:
                        general_fetched_urls.append(decoded_url)
                except requests.exceptions.SSLError:
                    # SSL certificate is not valid
                    print(f"SSL Error for URL: {link}")
                except requests.exceptions.RequestException as e:
                    # Handle other request exceptions (timeouts, connection errors, etc.)
                    print(f"Request Exception for URL: {link}, Error: {e}")



# Display the scraped URLs
print('General fetched Urls:')
print(general_fetched_urls)
all_fetched_urls=general_fetched_urls+google_maps_url
print('All fetched Urls:')
print(all_fetched_urls)
print("---------------------------------")

start_time = time.time()

# loader = WebBaseLoader(
#     web_paths=(scraped_urls),
#      bs_kwargs=dict(
#         # parse_only=bs4.SoupStrainer(
#         #     class_=("post-content", "post-title", "post-header")
#         # )
#     ),
# )

loader = AsyncChromiumLoader(all_fetched_urls, user_agent="MyAppUserAgent")
# docs = loader.load()
# docs[0].page_content[0:100]

docs = loader.load()
print(len(docs))

html2text = Html2TextTransformer()
docs_transformed = html2text.transform_documents(docs)
# docs_transformed[0].page_content[0:500]
print(f'docs_transformed 0:{docs_transformed[0]}')
print(f'docs_transformed 1:{docs_transformed[1]}')
print(f'docs_transformed 2:{docs_transformed[2]}')

# text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
# splits = text_splitter.split_documents(docs)
# vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)

# # Retrieve and generate using the relevant snippets of the blog.
# retriever = vectorstore.as_retriever()

# def format_docs(docs):
#     return "\n\n".join(doc.page_content for doc in docs)


# prompt = PromptTemplate(
#                                 input_variables = ['question', 'context'], 
#                                 template=
#                                 '''
#                                 You are a helpful touristic advisor bot. Your name is Adventura.
#                                 You help people find the best places to visit, eat and stay nearby their location.
#                                 Can you find me 10 places for {question} and include all details like:
#                                 - name
#                                 - description
#                                 - genre
#                                 - rating
#                                 - opening hours
#                                 - closing hours
#                                 - accurate address_location
#                                 - Link to their website
#                                 - any interesting information you have on them 
#                                 using this extra context: {context}
#                                 '''
#                                 )


# rag_chain = (
#     {"context": retriever | format_docs, "question": RunnablePassthrough()}
#     | prompt
#     | llm
#     | StrOutputParser()
# )

# input_data = {
#     'question': question,
# }


# llm_results=rag_chain.invoke(input=input_data)
# print(llm_results)

# elapsed_time = time.time() - start_time
# print(f"Execution time: {elapsed_time:.2f} seconds")


# # cleanup
# vectorstore.delete_collection()