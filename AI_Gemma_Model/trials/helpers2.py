import os
import dotenv , getpass

dotenv.load_dotenv()


langchain_tracing_v2 = os.getenv('LANGCHAIN_TRACING_V2')
langchain_api_key = os.getenv('LANGCHAIN_API_KEY')
langchain_project = os.getenv('LANGCHAIN_PROJECT')
langchain_endpoint = os.getenv('LANGCHAIN_ENDPOINT')


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
import time, json
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
from langchain.output_parsers import ResponseSchema, StructuredOutputParser, PydanticOutputParser
from langchain.globals import set_verbose, set_debug
from langchain_core.prompts.few_shot import FewShotPromptTemplate
from langchain_core.prompts.prompt import PromptTemplate
from langchain_core.example_selectors import SemanticSimilarityExampleSelector
from fastapi import FastAPI
from langserve import add_routes
import uvicorn
from langserve import APIHandler
import urllib
from fastapi import FastAPI, HTTPException, Body, Header, Request, BackgroundTasks
from langchain_core.runnables import RunnableLambda
from fastapi import Depends, FastAPI, Request, Response
from typing import Annotated
from sse_starlette import EventSourceResponse
from fastapi.responses import JSONResponse
import asyncio
from threading import Event
