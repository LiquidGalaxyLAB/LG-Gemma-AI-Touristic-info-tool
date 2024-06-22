from helpers import *

response_schemas = [
    ResponseSchema(name="countryName", description="Name of the country"),
    ResponseSchema(name="CityName", description="Name of the city"),
    ResponseSchema(
    name="PlacesList", description="List of places with their details following this example: [{placeName: string, address: [string], description: string, socialInformation: {string: string}, contactInformation: string, ratings: float, amenities: [string], prices: string}]", 
    type="array(objects)"
    )
]


output_parser = StructuredOutputParser.from_response_schemas(response_schemas)
format_instructions = output_parser.get_format_instructions()



llm = Ollama(model="gemma:7b")

user_query = "Attractions in London UK"


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Your answer must include Top 3 places. Each place must have the following information:
    - The name of the place
    - The address of the place
    - A brief description of the place and what makes it unique
    - Social media links (e.g., Facebook, Instagram, Twitter, official website)
    - Phone number or hotline
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
    partial_variables={"format_instructions": format_instructions},
)

chain = prompt | llm | output_parser

start_time=time.time()
result=chain.invoke({"question": user_query})
end_time=time.time()

print(result)
print("Time taken: ", end_time-start_time)


