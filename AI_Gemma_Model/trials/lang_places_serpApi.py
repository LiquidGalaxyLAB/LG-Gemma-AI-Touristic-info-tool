from langchain_community.utilities import GoogleSerperAPIWrapper

from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

# search = GoogleSerperAPIWrapper(type="places")
# results = search.results("Shopping in Cairo Egypt")
# print(results)


from langchain_community.utilities import SerpAPIWrapper
search = SerpAPIWrapper(search_engine='google', )
search.run("Pizza")