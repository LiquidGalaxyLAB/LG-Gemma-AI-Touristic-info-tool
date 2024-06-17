
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

embeddings = (
    OllamaEmbeddings(model="all-minilm")
)  
llm = Ollama(model="gemma:2b")



loader = WebBaseLoader(
    web_paths=("https://www.tripadvisor.com/Search?q=sight+seeing+cairo+egypt",),
    # bs_kwargs=dict(
    #     parse_only=bs4.SoupStrainer(
    #         class_=("post-content", "post-title", "post-header")
    #     )
    # ),
)
docs = loader.load()

text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)

# Retrieve and generate using the relevant snippets of the blog.
retriever = vectorstore.as_retriever()
# prompt = hub.pull("rlm/rag-prompt")

def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)


prompt = PromptTemplate(
                                input_variables = ['query', 'city', 'country'], 
                                template=
                                '''
                                You are a helpful touristic advisor bot. Your name is Adventura.
                                You help people find the best places to visit, eat and stay nearby their location.
                                Can you find me 10 places for {query} in {city}, {country} and include details like:
                                - name
                                - description
                                - genre
                                - rating
                                - opening hours
                                - closing hours
                                - accurate address_location
                                - Link to their website
                                - any interesting information you have on them 
                                using this extra context: {context}.
                                '''
                                )



rag_chain = (
    {"context": retriever | format_docs, "query": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)


rag_chain.invoke("Top sigh seeing places in Cairo Egypt")

# cleanup
vectorstore.delete_collection()