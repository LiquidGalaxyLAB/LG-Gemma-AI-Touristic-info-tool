from helpers import *



# # response_schemas = [
# #     ResponseSchema(name="generalDescription", description=" A brief description of the content of the list of places.", type= "string"),
# #     ResponseSchema(name="PlacesList", description= """A List of 10 JSON objects matching the structure
# # {placeName: string, address: string, city: string, country: string, description: string, ratings: float, amenities: [string], prices: string}
# # """, type="List")
# # ]


# # parser = StructuredOutputParser.from_response_schemas(response_schemas)
# # format_instructions = parser.get_format_instructions()

set_verbose(True)
set_debug(True)

class Place(BaseModel):
    name: str = Field(description="Full name of the place", default=None)
    address: str = Field(description="Address of the place", default=None)
    city: str = Field(description="Name of the city", default=None)
    country: str = Field(description="Name of the country", default=None)
    description: str = Field(description="A brief description", default=None)
    ratings: float = Field(description="Average rating", default=None) 
    amenities: str = Field(description="Amenities available", default=None)
    price: str = Field(description="Pricing info", default=None) 

class Places(BaseModel):
    places: List[Place] = Field(description="List of Place dictionaries", default=None)

parser = PydanticOutputParser(pydantic_object=Places)



# llm = Ollama(model="gemma:7b", num_ctx=8192, temperature=1.2, repeat_penalty=1.8, repeat_last_n=-1, verbose=True)

llm = Ollama(model="gemma:7b", num_ctx=8192)# default is 2048
print('Embeddings')
embeddings= (OllamaEmbeddings(model='nomic-embed-text',num_ctx=8192, temperature=1.2, show_progress=True, repeat_penalty=1.8, repeat_last_n=-1))   #8192 context windo like gemma 7b/2b context window
print('Done with embeddings')

user_query = "Attractions in Cairo Egypt"


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
Your answer must include the accurate address of each of the 10 places too.
Your answer must include addtional information such as: pricing, rating, and amenities.
If any of the information is not available to you, leave empty.
Do not omit any place from the list for brevity. 
Your answer MUST include all 10 places.
Your answer must be in a Well-defined JSON format, with correct curly braces, commas, and quotes. Only user double quotes for strings in your JSON format.
Each Place should include the following details: name, address, city, country, description, pricing, rating, amenities. 
The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.


QUESTION: {question}

YOUR ANSWER:""" 
'''


prompt = PromptTemplate(
    template=prompt_template,
    input_variables=["question",],
    # partial_variables={"format_instructions": parser.get_format_instructions()},
)

chain = prompt | llm 

# | parser


start_time=time.time()

result=chain.invoke({"question": user_query})
end_time=time.time()
print("Time taken: ", end_time-start_time)

print('result:')
print(result)

print('type of result:')
print(type(result))

parsed_result= parser.parse(result)

# result= {"places": [{"name": "Tower of London", "address": "106 London Bridge, London SE1 2AX", "city": "London", "country": "United Kingdom", "description": "A historic castle and royal palace, now a popular tourist attraction with a rich history and stunning views.", "pricing": "\u00a320.80", "rating": 4.8, "amenities": "Guided tours, gift shop, caf\u00e9"}, {"name": "British Museum", "address": "Great Russell Street, London WC1A 1AA", "city": "London", "country": "United Kingdom", "description": "A world-renowned museum with an extensive collection of artifacts from ancient civilizations to the present day.", "pricing": "Free entry", "rating": 4.9, "amenities": "Free Wi-Fi, caf\u00e9, reading room"}, {"name": "Hyde Park", "address": "Hyde Park, London W2 2BB", "city": "London", "country": "United Kingdom", "description": "A vast royal park in central London, known for its scenic landscapes, boating lake, and wildlife.", "pricing": "Free entry", "rating": 4.7, "amenities": "Picnic areas, boat rental, walking trails"}, {"name": "Natural History Museum", "address": "Cromwell Road, London SW7 5BD", "city": "London", "country": "United Kingdom", "description": "A natural history museum with a diverse collection of fossils, animals, and plants from around the world.", "pricing": "Free entry", "rating": 4.6, "amenities": "Guided tours, caf\u00e9, planetarium"}, {"name": "Tower Bridge", "address": "Tower Bridge, London SE1 2SW", "city": "London", "country": "United Kingdom", "description": "A iconic bridge over the River Thames, known for its unique design and stunning views of the city.", "pricing": "\u00a310.50", "rating": 4.9, "amenities": "Guided tours, climbing experiences, caf\u00e9"}, {"name": "Tate Modern", "address": "Tate Modern, Bankside, London SE1 9TG", "city": "London", "country": "United Kingdom", "description": "A contemporary art gallery with stunning views of the city from its rooftop terraces.", "pricing": "Free entry", "rating": 4.8, "amenities": "Free Wi-Fi, caf\u00e9, art workshops"}, {"name": "St. Paul's Cathedral", "address": "25 Old Change, London EC4A 4AA", "city": "London", "country": "United Kingdom", "description": "A magnificent cathedral with a towering dome and stained glass windows.", "pricing": "Free entry", "rating": 4.9, "amenities": "Guided tours, gift shop, caf\u00e9"}, {"name": "Westminster Abbey", "address": "20 Deans Yard, London SW1A 1AA", "city": "London", "country": "United Kingdom", "description": "A historic abbey church known for its royal connections and stunning architecture.", "pricing": "\u00a320.50", "rating": 4.8, "amenities": "Guided tours, gift shop, caf\u00e9"}, {"name": "Borough Market", "address": "85 Borough High Street, London SE1 1RL", "city": "London", "country": "United Kingdom", "description": "A vibrant food market with a wide variety of fresh produce, meats, and cheeses.", "pricing": "Free entry", "rating": 4.7, "amenities": "Caf\u00e9, street food stalls"}, {"name": "Camden Market", "address": "Camden Lock, Chalk Farm Road, London NW1 2PF", "city": "London", "country": "United Kingdom", "description": "A bustling market with a diverse range of goods, from fashion and jewelry to food and homeware.", "pricing": "Free entry", "rating": 4.6, "amenities": "Caf\u00e9, street food stalls"}]}
# json_string = json.dumps(result)
# parsed_result= parser.parse(json_string)


print('parsed result:')
print(parsed_result)


# # 1. Attempt to clean up the JSON
# try:
#     # Replace curly quotes, ensure proper comma separation, etc.
#     result = result.replace("“", '"').replace("”", '"')  
#     result = result.replace("'","\"")
#     # Other potential cleanup steps as needed...

#     # 2. Parse the cleaned-up JSON string into a Python dictionary
#     result_dict = json.loads(result)

#     # 3. Parse the dictionary using Pydantic
#     parsed_result = parser.parse(result_dict)
#     print('parsed result:')
#     print(parsed_result)

# except json.JSONDecodeError as e:
#     print(f"Error decoding JSON: {e}")
    # print(f"Raw LLM Output: {result}")




