
from langchain_core.output_parsers import StrOutputParser, JsonOutputParser
from langchain_core.pydantic_v1 import BaseModel, Field
from langchain_core.prompts import (
    PromptTemplate,
    ChatPromptTemplate,
    FewShotChatMessagePromptTemplate,
)
import time

query = "Best Pizza places"
city="Cairo"
country="Egypt"




from langchain.prompts import PromptTemplate




prompt_template = PromptTemplate(
                                input_variables = ['query', 'city', 'country', 'DuckDuckGo_Search'], 
                                template=
                                '''
                                You are a helpful touristic advisor bot. Your name is Adventura.
                                You help people find the best places to visit, eat and stay nearby their location.
                                Can you find me 10 places for {query} in {city}, {country} and include details like:
                                - name
                                - description
                                - genre
                                - rating
                                - opening hours
                                - closing hours
                                - accurate address_location
                                - Link to their website
                                - any interesting information you have on them 
                                using this search data: {DuckDuckGo_Search}.
                                '''
                                )

print(prompt_template)


from langchain_community.llms import Ollama
llm = Ollama(model="gemma:2b")


llm_chain= prompt_template | llm 


from langchain_community.tools import DuckDuckGoSearchResults

start_time = time.time()
search = DuckDuckGoSearchResults(num_results=10)
search_query= f"Best {query} in {city} {country}"
search_result = search.run(search_query)
print(search_result)


input_data = {
    'query': query,
    'city': city,
    'country': country,
    'DuckDuckGo_Search': search_result
}

llm_results = llm_chain.invoke(input=input_data)

print(llm_results)

elapsed_time = time.time() - start_time
print(f"Execution time: {elapsed_time:.2f} seconds")


'''
Results:

**1. Eatery:**
- Neapolitan pizzas in huge sizes (up to 50cm)
- Popular choices: Genovese and Truffle
- Rating: 4.5/5
- Open: 12 PM - 12 AM
- Address: New Cairo & Sheikh Zayed

**2. Sapori Di Carlo:**
- Authentic Italian vibes
- Mouthwatering Neapolitan pizzas
- Rating: 4.5/5
- Open: 12 PM - 11 PM
- Address: Zamalek

**3. Pizza Station:**
- Cairo's first New Yorker pizza by the slice
- Quick and delicious slices
- Rating: 4.3/5
- Open: 11:30 AM - 11 PM
- Address: Various locations

**4. Jimmy's Pizzeria:**
- Neapolitan & American-style pizzas
- Popular for their authentic calzones
- Rating: 4.2/5
- Open: 12 PM - 11 PM
- Address: Various locations

**5. La Casetta:**
- Popular for cheesy pizzas and mints
- Romantic atmosphere with live music
- Rating: 4.1/5
- Open: 12 PM - 11 PM
- Address: El-Mohandes Street, Heliopolis

**6. Pizzeria Napoli:**
- Authentic Neapolitan pizzas with fresh ingredients
- Excellent for takeout
- Rating: 4.0/5
- Open: 12 PM - 11 PM
- Address: Al-Motawalli Street, Mohandes

**7. Pizzeria 7th Street:**
- Wide variety of pizzas and toppings
- Known for their large pizzas
- Rating: 3.9/5
- Open: 11:30 AM - 11 PM
- Address: 7th Street, Heliopolis

**8. Mama Pizza:**
- Classic Italian pizzas with fresh flavors
- Relaxed and casual atmosphere
- Rating: 3.8/5
- Open: 12 PM - 10 PM
- Address: New Cairo

**9. Pizzeria Roma:**
- Authentic Italian pizza cooked in a wood-fired oven
- Extensive toppings and sizes available
- Rating: 3.7/5
- Open: 12 PM - 10 PM
- Address: Garden City

**10. Domino's Pizza:**
- Familiar pizza chain with classic toppings
- Good for large groups and late-night cravings
- Rating: 3.6/5
- Open: 10 AM - 12 AM
- Address: Various locations
'''