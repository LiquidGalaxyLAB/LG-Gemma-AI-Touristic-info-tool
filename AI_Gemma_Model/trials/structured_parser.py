from helpers import *

# response_schemas = [
#     ResponseSchema(
#     name="PlacesList", description="List of places with their details following this example: [{placeName: string, address: [string], city: string, country: string, description: string, socialInformation: {string: string}, contactInformation: string, ratings: float, amenities: [string], prices: string}]", 
#     type="array(objects)"
#     )
# ]


response_schemas = [
    ResponseSchema(name="PlacesList", description= """A List of 10 JSON objects matching the structure
{placeName: string, address: string, city: string, country: string, description: string, ratings: float, amenities: [string], prices: string}
""", type="List")
]


output_parser = StructuredOutputParser.from_response_schemas(response_schemas)
format_instructions = output_parser.get_format_instructions()



# llm = Ollama(model="gemma:7b")
llm = Ollama(model="gemma:7b", num_ctx=8192, temperature=1.2, repeat_penalty=1.8, repeat_last_n=-1)

user_query = "Attractions in London UK"


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
Your answer must include the accurate address of each of the 10 places too.
Your answer must include addtional information such as: pricing, rating, and amenities.
If any of the information is not available to you, leave empty.
Do not omit any place from the list for brevity. 
Your answer MUST include all 10 places.

{format_instructions}


QUESTION: {question}

YOUR ANSWER:"""
'''
# prompt_template = '''
# You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
# Your answer must include Top 3 places. Each place must have the following information:
#     - The name of the place
#     - The address of the place
#     - A brief description of the place and what makes it unique
#     - Social media links (e.g., Facebook, Instagram, Twitter, official website)
#     - Phone number or hotline
#     - Average rating based on user reviews
#     - List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.)
#     - Any pricing available for entry or services
# If any of the information is not available to you, leave empty.

# {format_instructions}


# QUESTION: {question}

# YOUR ANSWER:"""
# '''

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


