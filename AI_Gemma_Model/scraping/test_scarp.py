


def scrape_urls(user_query):
    general_fetched_urls=[]
    try:
        from googlesearch import search
    except ImportError: 
        print("No module named 'google' found")
    
    for url in search(user_query,num_results=10, ssl_verify=True, safe="active", lang="en"):
        if('tripadvisor' not in url):
            general_fetched_urls.append(url)
            print(url)
            if len(general_fetched_urls) >= 10:
               print('Fetched 10 URLs')
               break
    return general_fetched_urls


def test_scrape_urls():
    user_query = "best restaurants in Paris"
    urls = scrape_urls(user_query)
    print('len(urls):', len(urls))
    if(len(urls) < 10):
        print('Test failed: Expected at least 10 URLs, but got', len(urls))
    else:
        print("All tests passed successfully!")
    print('urls:', urls)

if __name__ == "__main__":
    test_scrape_urls()