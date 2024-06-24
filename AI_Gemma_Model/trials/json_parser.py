from helpers import *

# class Places(BaseModel):
#     countryName: str = Field(description="Name of the country")
#     cityName: str = Field(description="Name of the city")
#     places: 





# Define your desired data structure.
class PlaceData(BaseModel):
    placeName: str = Field(description="Full name of the place")
    cityName: str = Field(description="Name of the city")
    countryName: str = Field(description="Name of the country")
    address: List[str] = Field(description="a List of available addresses")
    description: str = Field(description="A brief description of the place and what makes it unique")
    ratings: float = Field(description="Average rating based on user reviews")
    amenities: List[str] = Field(description="List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.)")
    prices: str = Field(description="Any pricing available for entry or services")

class Places(BaseModel):
    places: List[PlaceData] = Field(description="List of 10 places")


parser = PydanticOutputParser(pydantic_object=Places)
parser.get_format_instructions()


llm = Ollama(model="gemma:7b")

user_query = "Attractions in London UK"

# Set up a parser + inject instructions into the prompt template.
parser = JsonOutputParser(pydantic_object=Places)


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Your answer must include Top 3 places. Each place must have the following information:
    - The name of the place
    - The address of the place
    - A brief description of the place and what makes it unique
    - Average rating based on user reviews
    - List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.)
    - Any pricing available for entry or services
If any of the information is not available to you, leave empty.

{format_instructions}


QUESTION: {question}

YOUR ANSWER:"""
'''

prompt = PromptTemplate(
    template=prompt_template,
    input_variables=["question"],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

chain = prompt | llm | parser

start_time=time.time()
result=chain.invoke({"question": user_query})
end_time=time.time()

print(result)
print("Time taken: ", end_time-start_time)


