
from helpers import *

# embeddings = (
#     OllamaEmbeddings(model="all-minilm")
# )  
embeddings= (OllamaEmbeddings(model='nomic-embed-text'))
llm = Ollama(model="gemma:7b")


user_query="Best pizza places in Cairo Egypt"

question_template_p1='Please, Can you help me find the Top 10 places for'
question_template_p2='and include all details you know about them such as name, address locations, description and more!'
question= f'{question_template_p1} {user_query} {question_template_p2}'


words = user_query.split()
url_search = '+'.join(words)
print(url_search)

seed_url=f'https://www.google.com/search?q={url_search}'
# google_maps_url=f'https://www.google.com/maps/search/{url_search}'
print('seed_url:',seed_url)
# print('google_maps_url:',google_maps_url)


general_fetched_urls=[]
# all_fetched_urls=[]


# headers = {
#     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'}

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer": "https://www.google.com/",
}

response = requests.get(seed_url, headers=headers)
if response.status_code == 200:
    page_content = response.text
    
    # Parse HTML content
    sp = soup(page_content, 'html.parser')
    
    # Find all <a> tags and extract URLs
    for a_tag in sp.find_all('a', href=True):
        link = a_tag['href']

        # Check if the link contains 'url=' and '&ved'
        if 'url=' in link and '&ved=' in link:
            # Extract the part after 'url='
            url_part = link.split('url=')[1]
            # Find the position of '&ved=' and slice the URL up to that position
            url = url_part.split('&ved=')[0]
            # Decode the URL to handle any URL encoding
            decoded_url = urllib.parse.unquote(url)
            
            # Ensure the URL starts with 'https://'
            if decoded_url.startswith('https://'):
                # scraped_urls.append(decoded_url)
                try:
                    # Try to make a request to the URL to check for SSL certificate validity
                    r = requests.get(decoded_url, headers=headers, verify=True, timeout=20)
                    # If the request is successful and no SSL errors are raised, add the URL to the list
                    # print(r.status_code)
                    if r.status_code == 200 or r.status_code == 520:
                            general_fetched_urls.append(decoded_url)
                            if len(general_fetched_urls) >= 8:
                                break
                except requests.exceptions.SSLError:
                    # SSL certificate is not valid
                    print(f"SSL Error for URL: {link}")
                except requests.exceptions.RequestException as e:
                    # Handle other request exceptions (timeouts, connection errors, etc.)
                    print(f"Request Exception for URL: {link}, Error: {e}")



# Display the scraped URLs
print('General fetched Urls:')
print(general_fetched_urls)
# all_fetched_urls.extend(general_fetched_urls)
# all_fetched_urls.extend(google_maps_url)

# print('All fetched Urls:')
# # print(all_fetched_urls)
print("---------------------------------")

start_time = time.time()

# loader = WebBaseLoader(
#     web_paths=(scraped_urls),
#      bs_kwargs=dict(
#         # parse_only=bs4.SoupStrainer(
#         #     class_=("post-content", "post-title", "post-header")
#         # )
#     ),
# )

loader = AsyncChromiumLoader(general_fetched_urls, user_agent="MyAppUserAgent")
# loader = AsyncChromiumLoader(['https://top10cairo.com/best-pizza-cairo/'], user_agent="MyAppUserAgent")
# docs = loader.load()
# docs[0].page_content[0:100]

docs = loader.load()
print(len(docs))

translator = Translator()
html2text = Html2TextTransformer()


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
# splits = text_splitter.split_documents(docs_transformed)
splits = text_splitter.split_documents(docs_transformed_english)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
print('vectorestore initialized')
# Retrieve and generate using the relevant snippets of the blog.

retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
print('retriever initialized')
print(retriever)
# def format_docs(docs):
#     return "\n\n".join(doc.page_content for doc in docs_transformed)


prompt_template = '''
You are a helpful touristic advisor bot that help people find the best places to visit, eat and stay nearby their location. Your name is Adventura.
Use the provided context as the basis for your answers and do not make up new reasoning paths - just mix-and-match what you are given.
Your answers must be concise and to the point, and refrain from answering about other topics than touristic information and the user question.

CONTEXT:
{context}

QUESTION: {question}

YOUR ANSWER:"""
'''

prompt = ChatPromptTemplate.from_template(prompt_template)

# prompt = PromptTemplate(
#                                 input_variables = ['question', 'context'], 
#                                 template=
#                                 '''
#                                 You are a helpful touristic advisor bot. Your name is Adventura.
#                                 You help people find the best places to visit, eat and stay nearby their location.
#                                 Can you find me 10 places for {question} and include all details like:
#                                 - name
#                                 - description
#                                 - genre
#                                 - rating
#                                 - opening hours
#                                 - closing hours
#                                 - accurate address_location
#                                 - Link to their website
#                                 - any interesting information you have on them 
#                                 using this extra context: {context}
#                                 '''
#                                 )


rag_chain = (
    {"context": retriever , "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# input_data = {
#     'question': question,
# }

print('Asking the model:')
# llm_results=rag_chain.invoke(input=input_data)
llm_results= rag_chain.invoke(question)
print(llm_results)

elapsed_time = time.time() - start_time
print(f"Execution time: {elapsed_time:.2f} seconds")


# cleanup
vectorstore.delete_collection()



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

