
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



#Scraping:
# biGQs _P fiohW ngXxk : name and url
# name: biGQs _P fiohW ngXxk

# url = 'https://www.tripadvisor.com/Search?q=best+cinemas+in+cairo+egypt'

# # Set headers to mimic a browser request
# # headers = {
# #     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
# #     'Accept-Language': 'en-US,en;q=0.9',
# #     'Accept-Encoding': 'gzip, deflate, br',
# #     'Connection': 'keep-alive'
# # }
# headers = {
#     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
#     'Accept-Language': 'en-US,en;q=0.9',
#     'Connection': 'keep-alive',
#     'Referer': 'https://www.google.com/'  # Sometimes setting a referer can help
# }

# try:
#     # Use a session to persist certain parameters across requests
#     session = requests.Session()
#     session.headers.update(headers)
    
#     response = session.get(url)
#     response.raise_for_status()  # Will raise an HTTPError for bad responses (4xx or 5xx)
#     print(response.status_code)
#     print(response.content)

#     bsobj = soup(response.content, 'lxml')
#     print(bsobj)
#     # You can now process bsobj to extract the information you need
#     # print(bsobj.prettify()[:500])  # Print first 500 characters of the parsed HTML for verification

#     places=[]
#     for name in bsobj.findAll('div', {'class':'biGQs _P fiohW ngXxk'}):
#         places.append(name.text.strip())
#     print(places)
#     ratings=[]
#     for rating in bsobj.findAll('a',{'class':'jVDab o W f u w hzzSG JqMhy'}):
#         ratings.append(rating['aria-label'])

#     print(ratings)

# except requests.exceptions.RequestException as e:
#     print(f"Error fetching the URL: {e}")

# print('start')
# html= requests.get('https://www.tripadvisor.in/Hotels-g187147-Paris_Ile_de_France-Hotels.html')
# print(html.status_code)
# bsobj= soup(html.content, 'lxml')

# places=[]
# for name in bsobj.findAll('div', {'class':'biGQs _P fiohW ngXxk'}):
#     places.append(name.text.strip())
# print(places)

#jVDab o W f u w hzzSG JqMhy
# ratings=[]
# for rating in bsobj.findAll('a',{'class':'jVDab o W f u w hzzSG JqMhy'}):
#     ratings.append(rating['aria-label'])

# print(ratings)


###################################3

embeddings = (
    OllamaEmbeddings(model="all-minilm")
)  
llm = Ollama(model="gemma:7b")


question="Best pizza places in Cairo Egypt"

words = question.split()
url_search = '+'.join(words)
print(url_search)
start_time = time.time()


   

loader = WebBaseLoader(
    web_paths=(f"https://www.tripadvisor.com/Restaurants-g294201-c31-Cairo_Cairo_Governorate.html",),
     bs_kwargs=dict(
        # parse_only=bs4.SoupStrainer(
        #     class_=("post-content", "post-title", "post-header")
        # )
    ),
)


# docs = loader.load()
# print(len(docs))
# print(f'docs 0:{docs[0]}')


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