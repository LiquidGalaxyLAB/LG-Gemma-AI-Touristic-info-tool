from helpers import *


app = FastAPI(
    title="LangChain Server",
    version="1.0",
    description="A simple api server using Langchain's Runnable interfaces",
)

llm = Ollama(model="gemma:7b", num_ctx=8192)
add_routes(
    app,
    llm,
    path="/gemma7b",
)

