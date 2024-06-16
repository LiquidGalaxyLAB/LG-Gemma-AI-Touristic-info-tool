import requests
import json

class SerpSearchTool:
    def __init__(self, api_key, query):
        self.api_key = api_key
        self.query = query

    def run(self):
        url = "https://google.serper.dev/search"
        payload = json.dumps({
            'q': self.query,
            'type': "news",
            'num': 5,
            'hl': 'en',
            #"key": google_api_key,
            #"cx": search_engine_id,
            #"dateRestrict": "2023-08-01:2023-08-28"
        })
        headers = {
            'X-API-KEY': self.api_key,
            'Content-Type': 'application/json'
        }
        response = requests.request("POST", url, headers=headers, data=payload)
        response_data = response.json()
        #pprint.pp("Search results: ", response_data)
        #print("Search pars: ", response_data['searchParameters'])
        #news if type is news, and organic if type is search
        # for i, item in enumerate(response_data['news']):
        #     print(response_data['news'][i])
        return response_data['news']