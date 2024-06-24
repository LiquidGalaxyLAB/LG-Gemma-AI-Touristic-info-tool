from helpers import *



# response_schemas = [
#     ResponseSchema(name="generalDescription", description=" A brief description of the content of the list of places.", type= "string"),
#     ResponseSchema(name="PlacesList", description= """A List of 10 JSON objects matching the structure
# {placeName: string, address: string, city: string, country: string, description: string, ratings: float, amenities: [string], prices: string}
# """, type="List")
# ]


# parser = StructuredOutputParser.from_response_schemas(response_schemas)
# format_instructions = parser.get_format_instructions()

set_verbose(True)
set_debug(True)

class Place(BaseModel):
    name: str = Field(description="Full name of the place")
    address: str = Field(description="Address of the place")
    city: str = Field(description="Name of the city")
    country: str = Field(description="Name of the country")
    description: str = Field(description="A brief description")
    ratings: float = Field(description="Average rating", default=None) 
    amenities: List[str] = Field(description="List of amenities", default=None)
    price: str = Field(description="Pricing info", default=None) 

class Places(BaseModel):
    generalDescription: str = Field(description="Brief description of the places")
    PlacesList: List[Place] = Field(description="List of Place dictionaries")

parser = PydanticOutputParser(pydantic_object=Places)



llm = Ollama(model="gemma:7b", num_ctx=8192, temperature=1.2, repeat_penalty=1.8, repeat_last_n=-1, verbose=True)
print('Embeddings')
embeddings= (OllamaEmbeddings(model='nomic-embed-text',num_ctx=8192, temperature=1.2, show_progress=True, repeat_penalty=1.8, repeat_last_n=-1))   #8192 context windo like gemma 7b/2b context window
print('Done with embeddings')

user_query = "Attractions in London UK"


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

chain = prompt | llm | parser


start_time=time.time()

result=chain.invoke({"question": user_query})
end_time=time.time()
print("Time taken: ", end_time-start_time)

print('result:')
print(result)

print('type of result:')
print(type(result))

# parsed_result= parser.parse(result)
# print('parsed result:')
# print(parsed_result)


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




'''
```
{"properties": 
            {
                "general_description": 
                                        {"title": "General Description", 
                                        "description": "A brief description of the content of the list of places.", 
                                        "type": "string"}, 
                "places": 
                        {"title": "Places", 
                        "description": "Python list of dictionaries containing place name, address, city, country, description, ratings, amenities, and prices.", 
                        "type": "array", "items": {}
                        }
            }, 
 "required": ["general_description", "places"]
}       
```

'''