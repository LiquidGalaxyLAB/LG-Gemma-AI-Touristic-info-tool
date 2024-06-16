# from langchain_community.tools import DuckDuckGoSearchRun

# search = DuckDuckGoSearchRun()
# print(search.run("Best pizza places in cairo Egypt"))


# from langchain_community.utilities import DuckDuckGoSearchAPIWrapper

# wrapper = DuckDuckGoSearchAPIWrapper(region="ar-eg", time="d", max_results=2)
# search = DuckDuckGoSearchResults(api_wrapper=wrapper, source="places")
# print(search.run("Best yoga studios in cairo Egypt"))




#BEST:
from langchain_community.tools import DuckDuckGoSearchResults
search = DuckDuckGoSearchResults()
print(search.run("Best salons in cairo Egypt"))


