from langchain_community.llms import Ollama
from langchain_core.output_parsers import StrOutputParser, JsonOutputParser
from langchain_core.pydantic_v1 import BaseModel, Field
from langchain_core.prompts import (
    PromptTemplate,
    ChatPromptTemplate,
    FewShotChatMessagePromptTemplate,
)



llm = Ollama(model="gemma:7b")

final_prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "You are a helpful touristic advisor bot. You help people find the best places to visit, eat and stay nearby their location. Your name is Adventura."),
        ("human", "Hello, how are you doing?"),
        ("ai", "I'm doing well, thanks!"),
        ("human", "Well, Currently I am in {input_place}. Would you be my tour guide and help me discover whatever I need to know about this place?"),
        ("ai", "Sure! I can help you with that. What would you like to know?"),
        # few_shot_prompt,
        ("human", "I am looking for the {input_query} in {input_place}, {country_name}. Can you find me 10 top-rated places and include details like name, description, genre, rating, opening hours, closing hours, address_location and any interesting information you have on them?"),
    ],
)
parser = StrOutputParser()


chain = final_prompt | llm | parser

print(chain.invoke({"input_query": "best Yoga Studios", "input_place": "Cairo", "country_name": "Egypt"}))






'''

# llm = Ollama(model="gemma:7b")

# # prompt_template = PromptTemplate.from_template(
# #     "Tell me a {adjective} joke about {content}."
# # )
# # prompt_template.format(adjective="funny", content="chickens")


# # examples = [
# #     {"input": "2+2", "output": "4"},
# #     {"input": "2+3", "output": "5"},
# # ]

# # # This is a prompt template used to format each individual example.
# # example_prompt = ChatPromptTemplate.from_messages(
# #     [
# #         ("human", "{input}"),
# #         ("ai", "{output}"),
# #     ]
# # )
# # few_shot_prompt = FewShotChatMessagePromptTemplate(
# #     example_prompt=example_prompt,
# #     examples=examples,
# # )

# # print(few_shot_prompt.format())



# final_prompt = ChatPromptTemplate.from_messages(
#     [
#         ("system", "You are a helpful touristic advisor bot. You help people find the best places to visit, eat and stay nearby their location. Your name is Adventura."),
#         ("human", "Hello, how are you doing?"),
#         ("ai", "I'm doing well, thanks!"),
#         ("human", "Well, Currently I am in {input_place}. Would you be my tour guide and help me discover whatever I need to know about this place?"),
#         ("ai", "Sure! I can help you with that. What would you like to know?"),
#         # few_shot_prompt,
#         ("human", "I am looking for the {input_query} in {input_place}, {country_name}. Can you find me 10 top-rated places and include details like name, description, genre, rating, opening hours, closing hours, address_location and any interesting information you have on them?"),
#     ],
# )

# # messages = final_prompt.format_messages(input_place="Zamalek", input_query="best top-rated pizza places", country_name="Egypt")

# parser = StrOutputParser()

# # prompt = PromptTemplate(
# #     template="Answer the user query.\n{format_instructions}\n{query}\n",
# #     input_variables=["query"],
# #     partial_variables={"format_instructions": parser.get_format_instructions()},
# # )

# chain = final_prompt | llm | parser

# print(chain.invoke({"input_place": "New Cairo", "input_query": "best Yoga Studios", "country_name": "Egypt"}))


'''


