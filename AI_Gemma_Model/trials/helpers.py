import os
import dotenv , getpass

dotenv.load_dotenv()


langchain_tracing_v2 = os.getenv('LANGCHAIN_TRACING_V2')
langchain_api_key = os.getenv('LANGCHAIN_API_KEY')
langchain_project = os.getenv('LANGCHAIN_PROJECT')
langchain_endpoint = os.getenv('LANGCHAIN_ENDPOINT')

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
from langchain_core.prompts import PromptTemplate, ChatPromptTemplate
from langsmith.wrappers import wrap_openai
from langsmith import traceable
from langsmith import Client
from langsmith.evaluation import evaluate
import time
import requests
from bs4 import BeautifulSoup as soup
import urllib.parse
from langchain_community.document_loaders import AsyncChromiumLoader
from langchain_community.document_transformers import Html2TextTransformer
from langdetect import detect
from googletrans import Translator
from langchain_core.output_parsers import JsonOutputParser
from langchain_core.pydantic_v1 import BaseModel, Field
from typing import List, Dict
from langchain.output_parsers import ResponseSchema, StructuredOutputParser
from langchain.globals import set_verbose, set_debug

# Importing LangSmith
# from langsmith.tracing import Tracer

# # Set up the tracer
# tracer = Tracer()

# # Create LangSmith client
# langsmith_client = LangSmith(api_key=os.getenv('LANGCHAIN_API_KEY'))

# # Configure logging
# import logging
# logging.basicConfig(level=logging.DEBUG)
