
from helpers import *


embeddings= (OllamaEmbeddings(model='nomic-embed-text'))   #8192 context windo like gemma 7b/2b context window
llm = Ollama(model="gemma:7b")


user_query="Attractions in Tokyo Japan"

# question_template_p1='Please, Can you help me find the Top 10 places for'
# question_template_p2='and include all details you know about them such as name, address locations, description and more!'
# question= f'{question_template_p1} {user_query} {question_template_p2}'
question= f'{user_query}'

words = user_query.split()
url_search = '+'.join(words)
print(url_search)

seed_url=f'https://www.google.com/search?q={url_search}'

print('seed_url:',seed_url)


general_fetched_urls=[]


headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer": "https://www.google.com/",
}

response = requests.get(seed_url, headers=headers)
if response.status_code == 200:
    page_content = response.text
    
    sp = soup(page_content, 'html.parser')
    
    for a_tag in sp.find_all('a', href=True):
        link = a_tag['href']

        if 'url=' in link and '&ved=' in link:
            url_part = link.split('url=')[1]
            url = url_part.split('&ved=')[0]
            decoded_url = urllib.parse.unquote(url)
            
            # Ensure the URL starts with 'https://'
            if decoded_url.startswith('https://'):
                try:
                    r = requests.get(decoded_url, headers=headers, verify=True, timeout=20)
                    # print(r.status_code)
                    if r.status_code == 200 or r.status_code == 520:
                            general_fetched_urls.append(decoded_url)
                            if len(general_fetched_urls) >= 8:
                                break
                except requests.exceptions.SSLError:
                    print(f"SSL Error for URL: {link}")
                except requests.exceptions.RequestException as e:
                    print(f"Request Exception for URL: {link}, Error: {e}")



# Display the scraped URLs
print('General fetched Urls:')
print(general_fetched_urls)

print("---------------------------------")

start_time = time.time()


loader = AsyncChromiumLoader(general_fetched_urls, user_agent="MyAppUserAgent")
docs = loader.load()
print(len(docs))
html2text = Html2TextTransformer()
translator = Translator()

## Function to detect language and filter non-English documents
def is_english(text):
    try:
        return detect(text) == 'en'
    except:
        return False

# def translate_to_english(text):
#     is_detected_english = is_english(text)
#     if is_detected_english:
#         return text
#     else:
#         translated_text = translator.translate('اهلا', dest='en')
#         return translated_text

# final_docs=[]
# docs_transformed = html2text.transform_documents(docs)
# for doc in docs_transformed:
#   translated_content = translate_to_english(doc)
#   final_docs.append(translated_content)

# print(len(final_docs))
# print(final_docs[0])


html2text = Html2TextTransformer()
docs_transformed = html2text.transform_documents(docs)
docs_transformed[0].page_content[0:500]
print(f'docs_transformed 0:{docs_transformed[0]}')
# print(f'docs_transformed 1:{docs_transformed[1]}')



# Filter out non-English documents
docs_transformed_english = [doc for doc in docs_transformed if is_english(doc.page_content)]
print(f'docs_transformed EN 0:{docs_transformed_english[0]}')
# print(f'docs_transformed EN 1:{docs_transformed_english[1]}')

text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs_transformed_english)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
print('vectorestore initialized')

retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
print('retriever initialized')
print(retriever)


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Use the provided context as the basis for your answers and do not make up new reasoning paths - just mix-and-match what you are given.
Your answer must include top 10 places with a brief description of each place, and what makes it unique.
Your answer must include the address of each of the 10 places too.
If available, include addtional information such as: pricing, rating, contact information, social media links, opening hours, amenities.

CONTEXT:
{context}

QUESTION: {question}

YOUR ANSWER:"""
'''

prompt = ChatPromptTemplate.from_template(prompt_template)

'''
Your answers must be concise and to the point, and refrain from answering about other topics than touristic information and the user question.

- Place name: 
  - List of Addresses: Full address of the place. Include all addresses available for this place.
  - Description: A brief description of the place, and any unique details of that place.
  - Contact Information: Phone number or hotline
  - Social Infomration: Any available social media links (e.g., Facebook, Instagram, Twitter, official website)
  - Ratings: Average rating based on user reviews (if available).


  - Rating: Average rating based on user reviews (if available).
  - Review counts
  - Opening Hours: Typical opening hours for each day of the week.
  - Contact Information: Phone number, email, and website (if available).
  - Amenities: List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.).
  - Prices: Any pricing available for entry or services.
'''

# context = "\n\n".join(doc.page_content for doc in docs_transformed_english)


# rag_chain = (
#     prompt
#     | llm
#     | StrOutputParser()
# )

# input_data = {
#     'question': question,
#     'context': context
# }

rag_chain = (
    {"context": retriever , "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)



print('Asking the model:')

llm_results= rag_chain.invoke(question)
# llm_results = rag_chain.invoke(input=input_data)
print(llm_results)

elapsed_time = time.time() - start_time
print(f"Execution time: {elapsed_time:.2f} seconds")


# # cleanup
# vectorstore.delete_collection()



'''  with old embedding (256 context)
**1. What The Crust:**

* Authentic Neapolitan pizza with AVPN affiliation.
* Handmade ovens, local & imported Italian ingredients.
* Friendly staff, fast service, delicious pizzas.
* Maadi, New Cairo, Sheikh Zayed.
* Contact: +201005764631, Facebook, Instagram, Website.

**2. 2900 Degrees:**

* Offers gourmet wood-fired pizza.
* Fresh toppings and traditional Italian recipes.
* Cozy atmosphere and friendly staff.
* Specific location not mentioned.

**3. La Vista 6 Ein Sokhna:**

* Houssam recommends their il tavolino pizza, claiming it's the best on TripAdvisor.
* No specific details provided.

**4. Mama Pizza:**

* Known for their delicious gourmet pizzas.
* Wide variety of toppings and crust options.
* Multiple locations throughout Cairo.

**5. Pizzeria Cairo:**

* Popular spot for classic Neapolitan pizza.
* Known for their generous slices and friendly staff.
* Multiple locations throughout Cairo.

**6. Pizza Garden:**

* Offers a wide range of pizzas at affordable prices.
* Great option for large groups or families.
* Multiple locations throughout Cairo.

**7. Mama Noura:**

* Local chain serving traditional Egyptian pizza with unique toppings.
* Known for their generous portions and affordable prices.
* Multiple locations throughout Cairo.

**8. Domino's Pizza:**

* Classic pizza chain with familiar flavors.
* Good option for quick delivery and familiar pizza.
* Multiple locations throughout Cairo.

**9. Pizza Hut:**

* Another classic pizza chain with familiar flavors.
* Good option for quick delivery and familiar pizza.
* Multiple locations throughout Cairo.

**10. Pizza Street:**

* Casual dining spot with a wide variety of pizzas.
* Offers vegetarian and vegan options.
* Multiple locations throughout Cairo.

'''
#Execution time: 878.01 seconds

'''  with new embeddings
## Top 10 Pizza Places in Cairo, Egypt:

**1. What The Crust:**
- Award-winning pizzeria included in "Top 100 Best Pizzerias in the World" list.
- Located in Downtown Mall New Cairo City.
- Opening hours: Mon-Thurs & Sat-Sun (12pm-12am), Fri (1pm-12am).
- Official website, Instagram, Facebook.

**2. Pizza Hut:**
- Hotline: 19000.
- Address: 18 Taha Hussein, Abu Al Feda, Zamalek.

**3. Papa John's:**
- Hotline: 19277.
- Address not provided.

**4. Vinny's Pizza:**
- Location not provided.

**5. Domino's:**
- Location not provided.

**6. Maison Thomas:**
- Location not provided.

**7. Il Divino:**
- Location not provided.

**8. Primo's Pizza:**
- Location not provided.

**9. Olivio Pizzeria & Bar:**
- Location not provided.

**10. Il Mulino Bakery & Restaurant:**
- Location not provided.

'''
#Execution time: 955.31 seconds




'''
## Top 10 Pizza Places in Cairo, Egypt:

**1. What The Crust:**
- Fifth Settlement and Maadi locations
- Neapolitan pizzas in huge sizes, highly rated
- Pricey side, but considered worth it

**2. Eatery:**
- New Cairo and Sheikh Zayed locations
- Wide variety of mouth-watering Neapolitan pizzas
- Popular choices: Genovese and Truffles

**3. Sapori Di Carlo:**
- Zamalek location
- Authentic vibes and delicious pizzas
- Must-try: Pollo E Pesto and Pepperonica

**4. Ted’s:**
- Widespread Cairo locations
- Authentic Neapolitan pizza with "All You Can Eat Pizza" option
- Choose your toppings for ultimate customization

**5. 900 Degrees Restaurant:**
- Variety of Neapolitan pizzas in Cairo

**6. Maison Thomas:**
- Zamalek, Sheikh Zayed, Heliopolis, New Cairo, Rehab branches
- Classic pizzeria since the 20s
- Popular toppings: Mexico, Margherita, Hot Dog

**7. Il Mulino Bakery & Restaurant:**
- Locations not specified
- Popular spot with wide range of pizzas

**8. Pizza Hut:**
- Hotline: 19000
- Classic pizza chain with familiar offerings

**9. Papa John’s:**
- Hotline: 19277
- Familiar pizza chain with standard toppings

**10. Olivio Pizzeria & Bar:**
- New Cairo location
- Authentic pizzas with traditional flavors and atmosphere
Execution time: 952.17 seconds

'''
'''
## Best Pizza Places in Italy

**1. Pizzeria Gino Sorbillo (Naples)**
- Address: Via Pietro Cirillo, 33, 80139 Naples, NA, Italy
- Rating: 4.9 (1200+ reviews)
- Opening Hours: Mon-Sun 12pm-12am
- Amenities: Outdoor seating, Wheelchair accessible
- Prices: €10-20

**2. Pepe in Grani (Caiazzo)**
- Address: Via Santa Maria di Costantinopoli, 53, 84010 Caiazzo, Campania, Italy
- Rating: 4.8 (300+ reviews)
- Opening Hours: Tues-Sun 12pm-1am
- Contact Information: +39 349 808 83 83
- Amenities: Outdoor seating, Reservations recommended
- Prices: €15-30

**3. L’Antica Pizzeria da Michele (Naples)**
- Address: Via dei Tribunali, 99, 80138 Naples, NA, Italy
- Rating: 4.9 (1800+ reviews)
- Opening Hours: Mon-Sun 10
-183

'''

'''
## Top 10 Attractions in Tokyo, Japan:

**1. Sensoji Temple** (Asakusa): Tokyo's oldest temple, known for its towering five-story pagoda and bustling Nakamise shopping street. (Address: 2-3-1 Asakusa, Taito, Tokyo 111-0035)

**2. Meiji Shrine** (Harajuku): A serene forest sanctuary with traditional Japanese architecture and stunning natural beauty. (Address: 1-1 Yoyogi, Shibuya, Tokyo 150-8301)

**3. Shibuya Crossing:** Witness the world's busiest crosswalk, teeming with pedestrians and dazzling lights. (Address: Shibuya Scramble Square, Shibuya, Tokyo 150-0012)

**4. Tokyo Tower:** Breathtaking panoramic views of the city from Tokyo's iconic landmark. (Address: 3-2-8 Shibuya, Shibuya, Tokyo 150-0010)

**5. Shinjuku Gyoen National Garden:** Escape the urban jungle with serene gardens, traditional teahouses, and cherry blossom groves. (Address: 1-4-1 Shinjuku, Shinjuku, Tokyo 160-0014)

**6. Tokyo Disneyland & DisneySea:** Experience the magic of Disney with thrilling rides, enchanting shows, and classic Disney characters. (Address: 1-13-13 Maihama, Urayasu, Chiba 270-0001)

**7. Imperial Palace Gardens:** Stroll through the lush gardens surrounding the Imperial Palace, home to the Japanese royalty. (Address: 1-1 Chiyoda, Chiyoda, Tokyo 100-8114)

**8. Harajuku:** Known for its vibrant fashion, youthful energy, and unique shops. (Address: Harajuku district, Shibuya, Tokyo)

**9. Odaiba:** A futuristic island with stunning waterfront views, futuristic architecture, and a variety of entertainment options. (Address: Odaiba Island, Tokyo Bay, Tokyo)

**10. Tokyo Skytree:** Enjoy breathtaking nighttime views from the tallest tower in Japan. (Address: 1-1-1 Tokyo Skytree, Tokyo 103-6470)

**Additional Information:**

* Many of these attractions have free entry or discounted rates for children and seniors.
* Opening hours vary, so check the official websites for detailed information.
* Tokyo Metro and various bus services offer convenient transportation options to reach these attractions.
Execution time: 1077.99 seconds

'''