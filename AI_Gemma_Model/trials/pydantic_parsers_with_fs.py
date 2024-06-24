from helpers import *
example1= { 
    "generalDescription": "Top-10 Pizza Restaurants around Cairo",  
    "PlacesList": 
            [
                {
                    "name": "DI SFORNO PIZZERIA", 
                    "address": "32 Bahgat Ali, Mohammed Mazhar, Zamalek",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Known for their delicious pizzas and great atmosphere.",    
                    "ratings": 4.8,
                    "prices": "",
                    "amenities": ["Dine-in", "Takeaway"]
                },
                {
                    "name": "Casa Della Past",
                    "address": "10 Gezira sporting club",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Serves tasty pizzas and offers both dine -In & take away options.",
                    "ratings": 4.3,
                    "prices": "",
                    "amenities": ["Dine-in", "Takeaway"]
                },
                {
                    "name": "Olivo Pizzeria & Bar",
                    "address": "18 Taha Hussein, Abu Al Feda, Zamalek",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Offers authentic Italian pizzas and casual dining experience.",
                    "ratings": 4.2,
                    "prices": "",
                    "amenities": ["Dine-in", "Takeaway"]
                },
                {
                    "name": "CaiRoma",
                    "address": "19 Youssef El-Gendy",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Casual eatery serving sweet & savory pizzas with a focus on perfect Italian pizza.",
                    "ratings": 4.2,
                    "prices": "$$$",
                    "amenities": ["Italian"]
                },
                {
                    "name": "Sapori di Carlo",
                    "address": "49 Mohammed Mazhar",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Serves delicious Italian pizza with friendly service.",
                    "ratings": 4.5,
                    "prices": "",
                    "amenities": ["Italian"]
                },
                {
                    "name": "What the Crust",
                    "address": "275 Makram Ebeid St",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Casual eatery for sweet & savory pizzas, known for having one of the best pizzas in Egypt.",
                    "ratings": 4.6,
                    "prices": "$$",
                    "amenities": ["Pizza"]
                },
                {
                    "name": "Pane Vino",
                    "address": "InterContinental Semiramis, Nile Corniche",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Serves delicious Italian pizza with a wide variety of toppings.",
                    "ratings": 4.5,
                    "prices": "$$",
                    "amenities": ["Italian"]
                },
                {
                    "name": "Maison Thomas",
                    "address": "157, 26th of July St, Mohammed Mazhar, Zamalek,",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Serves delicious Italian pizza with a wide variety of toppings.",
                    "ratings": 4.5,
                    "prices": "$$",
                    "amenities": ["Italian"]
                },
                {
                    "name": "900 Degrees Restaurant",
                    "address": "Downtown mall, New Cairo",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Variety of Neapolitan pizzas in Cairo",
                    "ratings": 4.3,
                    "prices": "$$",
                    "amenities": ["Italian", "Neapolitan"]
                },
                {
                    "name": "Ted's Pizzeria",
                    "address": "2FRG+P59, WaterWay, New Cairo 1",
                    "city": "Cairo",
                    "country": "Egypt",
                    "description": "Authentic Neapolitan pizza with 'All You Can Eat Pizza' option. Choose your toppings for ultimate customization",
                    "ratings": 4.0,
                    "prices": "$$",
                    "amenities": ["All you can eat Pizza"]
                }
            ] 
}

 
example2={ 
    "generalDescription": "London is a vibrant and historic city renowned for its iconic landmarks, world-renowned museums , thriving arts scene an rich culture.",  
    "PlacesList": 
            [
                {
                    "name": "Tower of London", 
                    "address": "160 Tower Bridge Road EC3N9HE",
                    "city": "Greater london",
                    "country": "United Kingdom.",
                    "description": "A historic castle that has served as a royal palace, prison and execution site",    
                    "ratings": 4.8,
                    "prices": "",
                    "amenities": ["Guided tours", "Educational programs"]
                },
                {
                    "name": "British Museum",
                    "address": "96-135 Great Russell Street WC2B-ISZ",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Home to an extensive collection of artifacts from human history",
                    "ratings": 4.7,
                    "prices": "- Free entry",
                    "amenities": ["Reading Room & Library"]
                },
                {
                    "name": "Big Ben",
                    "address": "Westminster London SW1A",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "An iconic clock tower and symbol of British culture",
                    "ratings": 4.9,
                    "prices": "- Free entry",
                    "amenities": ["Observation Deck"]
                },
                {
                    "name": "The London Dungeon",
                    "address": "Riverside Building, County Hall, Westminster Bridge Rd",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Hi-tech haunted house attraction",
                    "ratings": 4.3,
                    "prices": "From £25",
                    "amenities": ["Haunted house", "Themed experiences"]
                },
                {
                    "name": "The London Bridge Experience & London Tombs",
                    "address": "The Rennie Vaults, 2 - 4 Tooley St",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Theatrical performances, tours & a maze",
                    "ratings": 4.2,
                    "prices": "From £20",
                    "amenities": ["Theatrical performances", "Guided tours", "Maze"]
                },
                {
                    "name": "buckingham palace",
                    "address": "Westminster London SW1A",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "The London residence of the British monarch",
                    "ratings": 4.9,
                    "prices": "",
                    "amenities": ["Guided tours", "Changing of the Guard"]
                },
                {
                    "name": "London Eye",
                    "address": "Riverside Building, County Hall",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Giant observation wheel offering panoramic city views",
                    "ratings": 4.5,
                    "prices": "From £20",
                    "amenities": ["Observation wheel", "Restaurant"]
                },
                {
                    "name": "SEA LIFE London Aquarium",
                    "address": "Riverside Building, County Hall, Westminster Bridge Rd",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Oceanic exhibits for all ages",
                    "ratings": 4.3,
                    "prices": "From £20",
                    "amenities": ["Aquarium", "Educational programs"]
                },
                {
                    "name": "The Shard",
                    "address": "32 London Bridge St",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "Iconic skyscraper with city views",
                    "ratings": 4.9,
                    "prices": "From £25",
                    "amenities": ["Observation deck", "Restaurant"]
                },
                {
                    "name": "St Paul's Cathedral",
                    "address": "25 Old Palace Yard London EC1V-6BD",
                    "city": "London",
                    "country": "United Kingdom.",
                    "description": "A magnificent cathedral known for its towering dome and stained glass windows",
                    "ratings": 4.9,
                    "prices": "- Free entry",
                    "amenities": ["Guided tours", "Climb to the dome"]
                }
            ] 
}
json_string_example1= json.dumps(example1, indent=4)
json_string_example2= json.dumps(example2, indent=4)
print(type(json_string_example1))

# class Places(BaseModel):
#     countryName: str = Field(description="Name of the country")
#     cityName: str = Field(description="Name of the city")
#     places: 


# # Define your desired data structure.
# class PlaceData(BaseModel):
#     placeName: str = Field(description="Full name of the place")
#     cityName: str = Field(description="Name of the city")
#     countryName: str = Field(description="Name of the country")
#     address: List[str] = Field(description="a List of available addresses")
#     description: str = Field(description="A brief description of the place and what makes it unique")
#     ratings: float = Field(description="Average rating based on user reviews")
#     amenities: List[str] = Field(description="List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.)")
#     prices: str = Field(description="Any pricing available for entry or services")

# class Places(BaseModel):
#     general_description: str = Field(description="A brief description of the content of the list of places.")
#     places: list = Field(description="Python list of dictionaries containing place name, address, city, country, description, ratings, amenities, and prices.")


response_schemas = [
    ResponseSchema(name="generalDescription", description=" A brief description of the content of the list of places.", type= "string"),
    ResponseSchema(name="PlacesList", description= """A List of 10 JSON objects matching the structure
{placeName: string, address: string, city: string, country: string, description: string, ratings: float, amenities: [string], prices: string}
""", type="List")
]


parser = StructuredOutputParser.from_response_schemas(response_schemas)
format_instructions = parser.get_format_instructions()


# class Place(BaseModel):
#     name: str = Field(description="Full name of the place")
#     address: str = Field(description="Address of the place")
#     city: str = Field(description="Name of the city")
#     country: str = Field(description="Name of the country")
#     description: str = Field(description="A brief description")
#     ratings: float = Field(description="Average rating", default=None) 
#     amenities: List[str] = Field(description="List of amenities", default=None)
#     price: str = Field(description="Pricing info", default=None) 

# class Places(BaseModel):
#     generalDescription: str = Field(description="Brief description of the places")
#     PlacesList: List[Place] = Field(description="List of Place dictionaries")

# parser = PydanticOutputParser(pydantic_object=Places)

print('output schema:')
print(parser.get_format_instructions())

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

An Example that you must follow exactly:

{json_string_example1}

Output Format Instructions you must follow:

{format_instructions}


QUESTION: {question}

YOUR ANSWER:""" 

'''

# {answer}
#{format_instructions}



# examples = [
# {
# "question": "Best Pizza Places in Cairo Egypt",
# "answer": '"'+ json_string_example1 +'"'
# },
# {
# "question": "Attractions in London, UK",
# "answer": '"'+ json_string_example2 + '"'
# },

# ]


# example_prompt = PromptTemplate(
#     template=prompt_template,
#     input_variables=["question", "answer"],
#     partial_variables={"format_instructions": parser.get_format_instructions()},
# )

embeddings= (OllamaEmbeddings(model='nomic-embed-text',num_ctx=8192, temperature=1.2, show_progress=True, repeat_penalty=1.8, repeat_last_n=-1))   #8192 context windo like gemma 7b/2b context window
# example_selector = SemanticSimilarityExampleSelector.from_examples(
#     # This is the list of examples available to select from.
#     examples,
#     # This is the embedding class used to produce embeddings which are used to measure semantic similarity.
#     embeddings,
#     # This is the VectorStore class that is used to store the embeddings and do a similarity search over.
#     Chroma,
#     # This is the number of examples to produce.
#     k=1,
# )

# prefix="""
# You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
# Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
# Your answer must include the accurate address of each of the 10 places too.
# Your answer must include addtional information such as: pricing, rating, and amenities.
# If any of the information is not available to you, leave empty.
# Do not omit any place from the list for brevity. 
# Your answer MUST include all 10 places.

# {format_instructions}

# """

# suffix="""
# QUESTION: {input}

# YOUR ANSWER:

# """
# prompt = FewShotPromptTemplate(
#     example_selector=example_selector,
#     # examples=examples,
#     example_prompt=example_prompt,
#     # suffix="Question: {input}",
#     prefix=prefix,
#     suffix=suffix,
#     input_variables=["input"],
#     partial_variables={"format_instructions": parser.get_format_instructions()},
#     output_parser=parser
# )

prompt = PromptTemplate(
    template=prompt_template,
    input_variables=["question",],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

chain = prompt | llm | parser
# chain = prompt | llm 

start_time=time.time()
result=prompt.format(input=user_query)
result=chain.invoke({"question": user_query})
end_time=time.time()
print("Time taken: ", end_time-start_time)

print('unparsed result:')
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