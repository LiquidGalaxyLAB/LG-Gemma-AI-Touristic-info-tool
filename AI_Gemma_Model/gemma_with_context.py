'''
from langchain.prompts import ChatPromptTemplate

from langchain_community.vectorstores import Chroma
from langchain_community.document_loaders import JSONLoader
from langchain_community.embeddings import OpenAIEmbeddings

from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnableLambda, RunnablePassthrough

from langchain_openai import ChatOpenAI, OpenAIEmbeddings

embedding_function = OpenAIEmbeddings()

loader = JSONLoader(file_path="./prize.json", jq_schema=".prizes[]", text_content=False)
documents = loader.load()

db = Chroma.from_documents(documents, embedding_function)
retriever = db.as_retriever()

template = """Answer the question based only on the following context:
{context}

Question: {question}
"""
prompt = ChatPromptTemplate.from_template(template)

model = ChatOpenAI()

chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | model
    | StrOutputParser()
)

query = "What year did albert einstein win the nobel prize?"
print(chain.invoke(query))
'''