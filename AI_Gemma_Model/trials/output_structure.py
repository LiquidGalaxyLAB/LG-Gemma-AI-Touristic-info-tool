from helpers import *

llm = Ollama(model="gemma:7b", num_ctx=8192, temperature=1.2, repeat_penalty=1.8, repeat_last_n=-1)



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

print('output schema:')
print(parser.get_format_instructions())


prompt_template = '''
You are an AI model tasked with formatting JSON data. 
Your job is to take any incorrectly formatted JSON string and transform it into a properly formatted and indented JSON string. 
Ensure that the output is syntactically correct and adheres to standard JSON formatting rules.

{format_instructions}

UNSTRUCTURED DATA: {unstructured_data}

YOUR ANSWER:""" 
'''

prompt = PromptTemplate(
    template=prompt_template,
    input_variables=["unstructured_data",],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

chain= prompt | llm | parser

unstructured_data='''
{  "generalDescription":"London is a vibrant and historic city filled with world-renowned landmarks, charming neighborhoods ,and diverse attractions for travelers of all interests.",   “PlacesList”: [ { “name": "Tower Bridge",    ”address: '80 London Tower Millennium Road',     'city': ‘Greater london’,  "country ":’United Kingdom”,
      description ':A stunning Gothic Revival bridge with iconic walkways and offering breathtaking views.',       rating :4.9,        “amenities”: ['Café/Restaurant'],         price:"Free Entry",    }, { “name": "British Museum ",   ”address': '160–328 Cromwell Road',  "city ': ‘London’,
      'country':'United Kingdom’ ', description: ’A world-leading museum housing a vast collection of ancient artifacts from around the globe.',     rating :5.o,         “amenities": ['Gift Shop'],          price:"Free Entry",    }, { “name”: "Hyde Park ",   "address': 'London SW1a 2BB',  'city ': ‘Greater London’,
       ‘country’:’United Kingdom,’        description: ’A vast urban park in central london known for its serene lake and lush landscapes.',     rating :4.9,         “amenities": ['Picnic area'],   price:"Free Entry",    }, { “name”: "Tower ofLondon ",  "address': '80 London Tower Millennium Road',      'city ': ‘Greaterlondon’,
       ‘country’:’United Kingdom,’        description: ’A historic castle that served as a royal palace, prison and execution site.',     rating :4.9,"amenities": ['Guided tours'], price:"£26-35",    }, { “name”: "The National Gallery ",  "address': 'Trafalgar Square',   'city ': ‘London’,
       ‘country’:’United Kingdom,’        description: ’A renowned art gallery showcasing works of European masters from the Middle Ages to present.',     rating :4.8,"amenities": ['Gift shop'], price:"Free Entry",    }, { “name”: "St Pauls Cathedral ",  "address': '25 York Road',   'city ': ‘London’,
       ‘country’:’United Kingdom,’        description: ’A magnificent cathedral known for its towering dome and stunning interior.',     rating :4.9,"amenities": ['Guided tours'], price:"Free Entry",    }, { “name”: "Westminster Abbey ",  "address': '20 Deans Yard',   'city ': ‘London’,
       ‘country’:’United Kingdom,’        description: ’A historic abbey known for its royal connections and stunning Gothic architecture.',     rating :4.9,"amenities": ['Guided tours'], price:"Free Entry",    }, { “name”: "Hampton Court Palace ",  "address': '1 Hampton court Road',   'city ': ‘London’,       
       ‘country’:’United Kingdom,’        description: ’A majestic palace with stunning gardens and rich history.',     rating :4.8,"amenities": ['Guided tours'], price:"£23-79",    }, { “name”: "Borough Market ",  "address': 'Market Road',   'city ': ‘London’,
       ‘country’:’United Kingdom,’        description: ’A vibrant food market renowned for its diverse stalls and local produce.',     rating :4.8,"amenities": ['Café/Restaurant'], price:"Free Entry",    }, { “name”: "Tate Modern ",  "address': 'Bankside',   'city ': ‘London’,
       ‘country’:’United Kingdom,’        description: ’A contemporary art gallery offering stunning views of the Thames River.',     rating :4.9,"amenities": ['Gift Shop'], price:"Free Entry",    } ] }

'''

start_time=time.time()

result=chain.invoke({"unstructured_data": unstructured_data})
end_time=time.time()
print("Time taken: ", end_time-start_time)

print('result:')
print(result)