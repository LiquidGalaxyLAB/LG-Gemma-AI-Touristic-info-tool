
from helpers import *

llm = Ollama(model="gemma:7b")
embeddings= (OllamaEmbeddings(model='nomic-embed-text'))

place='Maison Thomas Cairo Egypt'
user_query="Can you tell me details about Maison Thomas place in Cairo Egypt?"


words = place.split()
url_search = '+'.join(words)
print(url_search)




start_time = time.time()

google_maps_url=f'https://www.google.com/maps/search/{url_search}'

loader = AsyncChromiumLoader([google_maps_url], user_agent="MyAppUserAgent")

docs = loader.load()
print(len(docs))

translator = Translator()
html2text = Html2TextTransformer()

def is_english(text):
    try:
        return detect(text) == 'en'
    except:
        return False


html2text = Html2TextTransformer()
docs_transformed = html2text.transform_documents(docs)
docs_transformed[0].page_content[0:500]
print(f'docs_transformed 0:{docs_transformed[0]}')

docs_transformed_english = [doc for doc in docs_transformed if is_english(doc.page_content)]
print(f'docs_transformed EN 0:{docs_transformed_english[0]}')


text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
# splits = text_splitter.split_documents(docs_transformed)
splits = text_splitter.split_documents(docs_transformed_english)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings)
print('vectorestore initialized')
# Retrieve and generate using the relevant snippets of the blog.

retriever = vectorstore.as_retriever(search_kwargs={"k": 5})
print('retriever initialized')
print(retriever)



prompt_template= '''
                    You are an advanced AI assistant. Your task is to provide comprehensive information about a given place in a specified city and country. 
                    The information should include the following details:
                    - Address: Full address of the place.
                    - Description: A brief description of the place, including its significance, history, and any notable features.
                    - Rating: Average rating based on user reviews (if available).
                    - Opening Hours: Typical opening hours for each day of the week.
                    - Contact Information: Phone number, email, and website (if available).
                    - Amenities: List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.).
                    - Prices: Any pricing available for entry or services.
                    Use the provided context as the basis for your answers and do not make up new reasoning paths.
                    Your answers must be concise and to the point.

                    CONTEXT:
                    {context}


                    QUESTION: {question}

                    YOUR ANSWER:"""
                '''
prompt = ChatPromptTemplate.from_template(prompt_template)

# prompt= PromptTemplate(
#     input_variables = ['question'], 
#     template=
#                 '''
#                 You are an advanced AI assistant. Your task is to provide comprehensive information about a given place in a specified city and country. You should include
#                 The information should include the following details:
#                 - Address: Full address of the place.
#                 - Description: A brief description of the place, including its significance, history, and any notable features.
#                 - Rating: Average rating based on user reviews (if available).
#                 - Opening Hours: Typical opening hours for each day of the week.
#                 - Contact Information: Phone number, email, and website (if available).
#                 - Amenities: List of amenities available at the place (e.g., Wi-Fi, parking, restrooms, etc.).
#                 - Prices: Any pricing available for entry or services.
#                 QUESTION: {question}

#                 YOUR ANSWER:"""
#                 '''
# )


# llm_chain= prompt | llm | StrOutputParser()


rag_chain = (
    {"context": retriever , "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

print('Asking the model:')

llm_results= rag_chain.invoke(user_query)
print(llm_results)

elapsed_time = time.time() - start_time
print(f"Execution time: {elapsed_time:.2f} seconds")