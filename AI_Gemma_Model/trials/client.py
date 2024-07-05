from helpers import *

from langserve import RemoteRunnable

remote_runnable = RemoteRunnable("http://localhost:8000/ragChain")

user_query = "Cycling Tours Worldwide"
print(remote_runnable.invoke(user_query))

# response= requests.post("http://localhost:8000/ragChain/invoke", json={"question": "Cycling Tours Worldwide"})

# print(response.json())