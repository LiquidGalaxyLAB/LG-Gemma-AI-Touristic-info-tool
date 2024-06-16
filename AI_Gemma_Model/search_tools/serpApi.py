from serpapi import GoogleSearch

import os
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

params = {

  "engine": "google_maps",
  "q": "Top Attractions",
  "ll": "@31.205753,29.924526,15.1z",
  "type": "search",
  "api_key": ""
}

search = GoogleSearch(params)
results = search.get_dict()
# print(results)
local_results = results["local_results"]
print(local_results)



'''
[
    {
        'position': 1, 
        'title': "Joe's Pizza Broadway", 
        'place_id': 'ChIJifIePKtZwokRVZ-UdRGkZzs', 
        'data_id': '0x89c259ab3c1ef289:0x3b67a41175949f55', 
        'data_cid': '4280570365733019477', 
        'reviews_link': 'https://serpapi.com/search.json?data_id=0x89c259ab3c1ef289%3A0x3b67a41175949f55&engine=google_maps_reviews&hl=en', 
        'photos_link': 'https://serpapi.com/search.json?data_id=0x89c259ab3c1ef289%3A0x3b67a41175949f55&engine=google_maps_photos&hl=en', 
        'gps_coordinates': {'latitude': 40.754679499999995, 'longitude': -73.9870291}, 
        'place_id_search': 'https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJifIePKtZwokRVZ-UdRGkZzs', 
        'provider_id': '/g/11bw4ws2mt', 
        'rating': 4.5, 
        'reviews': 18548, 
        'price': '$', 
        'type': 'Pizza restaurant', 
        'types': ['Pizza restaurant', 'Pizza delivery', 'Restaurant'], 
        'type_id': 'pizza_restaurant', 
        'type_ids': ['pizza_restaurant', 'pizza_delivery_service', 'restaurant'], 
        'address': '1435 Broadway, New York, NY 10018', 
        'open_state': 'Open ⋅ Closes 5\u202fAM ⋅ Reopens 10\u202fAM', 
        'hours': 'Open ⋅ Closes 5\u202fAM ⋅ Reopens 10\u202fAM', 
        'operating_hours': {'saturday': '10\u202fAM–5\u202fAM', 'sunday': '10\u202fAM–3\u202fAM', 'monday': '10\u202fAM–3\u202fAM', 'tuesday': '10\u202fAM–3\u202fAM', 'wednesday': '10\u202fAM–3\u202fAM', 'thursday': '10\u202fAM–3\u202fAM', 'friday': '10\u202fAM–5\u202fAM'}, 
        'phone': '(646) 559-4878', 
        'website': 'http://joespizzanyc.com/', 
        'description': 'Classic NYC slice shop. Modern outpost of a longtime counter-serve pizza joint prepping New York-style slices and pies.', 
        'service_options': {'dine_in': True, 'takeout': True, 'no_contact_delivery': True}, 
        'order_online': 'https://food.google.com/chooseprovider?restaurantId=/g/11bw4ws2mt&g2lbs=AOHF13mrJzf5fKgOSjO8_RUN7DsjUcGXB40e6w_kB2khea4QpRtArabElKHcnwy1TrLKzghXLYMEgO0xbZkV1WM517gNohJVfzrkCd62VNNjwsBS8pXufI0%3D&hl=en-US&gl=us&fo_m=MfohQo559jFvMUOzJVpjPL1YMfZ3bInYwBDuMfaXTPp5KXh-&utm_source=tactile&gei=8ZJuZr3mO7H9ptQP2eqTqA0&ei=8ZJuZr3mO7H9ptQP2eqTqA0&fo_s=OA,SOE&opi=79508299&foub=mcpp', 
        'thumbnail': 'https://lh5.googleusercontent.com/p/AF1QipOckRXnqWjhGobtg6WpQUunzISOfAqN5bobAsFo=w122-h92-k-no'
    }, 
        
    {
        'position': 2, 
        'title': "Joe's Pizza on 8th Ave", 
        'place_id': 'ChIJs059wrtZwokRdpPNbdIjuxg', 
        'data_id': '0x89c259bbc27d4eb3:0x18bb23d26dcd9376', 
        'data_cid': '1782057464247456630', 
        'reviews_link': 'https://serpapi.com/search.json?data_id=0x89c259bbc27d4eb3%3A0x18bb23d26dcd9376&engine=google_maps_reviews&hl=en', 
        'photos_link': 'https://serpapi.com/search.json?data_id=0x89c259bbc27d4eb3%3A0x18bb23d26dcd9376&engine=google_maps_photos&hl=en', 
        'gps_coordinates': {'latitude': 40.743913899999995, 'longitude': -73.9997923}, 
        'place_id_search': 'https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJs059wrtZwokRdpPNbdIjuxg', 
        'provider_id': '/g/1hc1bz13k', 
        'rating': 3.8, 
        'reviews': 661, 
        'price': '$', 
        'unclaimed_listing': True, 
        'type': 'Pizza restaurant', 
        'types': ['Pizza restaurant', 'Delivery Restaurant', 'Takeout Restaurant', 'Pizza delivery', 'Pizza Takeout'], 
        'type_id': 'pizza_restaurant', 
        'type_ids': ['pizza_restaurant', 'meal_delivery', 'meal_takeaway', 'pizza_delivery_service', 'pizzatakeaway'], 
        'address': '211 8th Ave, New York, NY 10011', 'open_state': 'Closes soon ⋅ 3:45\u202fAM ⋅ Reopens 11\u202fAM', 
        'hours': 'Closes soon ⋅ 3:45\u202fAM ⋅ Reopens 11\u202fAM', 
        'operating_hours': {'saturday': '10\u202fAM–3:45\u202fAM', 'sunday': '11\u202fAM–11\u202fPM', 'monday': '10\u202fAM–11:45\u202fPM', 'tuesday': '10\u202fAM–11:45\u202fPM', 'wednesday': '10\u202fAM–11:45\u202fPM', 'thursday': '10\u202fAM–1:45\u202fAM', 'friday': '10\u202fAM–3:45\u202fAM'}, 
        'phone': '(212) 243-3226', 
        'website': 'https://www.joespizza8thave.com/?utm_source=gbp', 
        'description': 'Pizzeria serving heroes & pastas too. Classic pizzeria offering slices & pies, heroes & pastas; open late on weekends.', 
        'service_options': {'dine_in': True, 'curbside_pickup': True, 'no_contact_delivery': True}, 
        'order_online': 'https://food.google.com/chooseprovider?restaurantId=/g/1hc1bz13k&g2lbs=AOHF13n66VB_Pyt5llX6KQbGoaHoINHd53vQmkz9WgFu-B2oIFhApjX922BiUCFcJUn4fntTRW_2sSxviqBLVXJUobT6kVxQMMtlemlsaLewiT0KAgeDPPk%3D&hl=en-US&gl=us&fo_m=MfohQo559jFvMUOzJVpjPL1YMfZ3bInYwBDuMfaXTPp5KXh-&utm_source=tactile&gei=8ZJuZr3mO7H9ptQP2eqTqA0&ei=8ZJuZr3mO7H9ptQP2eqTqA0&fo_s=OA,SOE&opi=79508299&foub=mcpp', 
        'thumbnail': 'https://lh5.googleusercontent.com/p/AF1QipNg0onVAC-s50FnzfRYt-U2VRAAlw18sG-QHW7I=w80-h142-k-no'
    }, 
        
    {
        'position': 3, 
        'title': "Rosa's Pizza", 
        'place_id': 'ChIJp8CXnK5ZwokRY61csxtqUwM', 
        'data_id': '0x89c259ae9c97c0a7:0x3536a1bb35cad63', 
        'data_cid': '239651872386624867', 
        'reviews_link': 'https://serpapi.com/search.json?data_id=0x89c259ae9c97c0a7%3A0x3536a1bb35cad63&engine=google_maps_reviews&hl=en', 
        'photos_link': 'https://serpapi.com/search.json?data_id=0x89c259ae9c97c0a7%3A0x3536a1bb35cad63&engine=google_maps_photos&hl=en', 
        'gps_coordinates': {'latitude': 40.7504175, 'longitude': -73.9907092}, 
        'place_id_search': 'https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJp8CXnK5ZwokRY61csxtqUwM', 
        'provider_id': '/g/1v7pzd6_', 
        'rating': 4.1, 
        'reviews': 869, 
        'price': '$', 
        'type': 'Pizza restaurant', 
        'types': ['Pizza restaurant'], 
        'type_id': 'pizza_restaurant', 
        'type_ids': ['pizza_restaurant'], 
        'address': '425 7th Ave, New York, NY 10001', 
        'open_state': 'Closes soon ⋅ 3:45\u202fAM ⋅ Reopens 10\u202fAM', 
        'hours': 'Closes soon ⋅ 3:45\u202fAM ⋅ Reopens 10\u202fAM', 
        'operating_hours': {'saturday': '10\u202fAM–3:45\u202fAM', 'sunday': '10\u202fAM–3:45\u202fAM', 'monday': '10\u202fAM–3:45\u202fAM', 'tuesday': '10\u202fAM–3:45\u202fAM', 'wednesday': '10\u202fAM–3:45\u202fAM', 'thursday': '10\u202fAM–3:45\u202fAM', 'friday': '10\u202fAM–3:45\u202fAM'}, 
        'phone': '(646) 998-3044', 
        'website': 'http://rosaspizzanewyork.com/?utm_source=gbp', 
        'description': "Penn Station slice joint. Counter spot serving basic pizza & cheap beer on Penn Station's Long Island Rail Road level.", 
        'service_options': {'dine_in': True, 'takeout': True, 'no_contact_delivery': True}, 
        'order_online': 'https://food.google.com/chooseprovider?restaurantId=/g/1v7pzd6_&g2lbs=AOHF13kTfARNIAOnrPmhypt8jdfI62fs7OMhd9d-QrS0or11F04xXlt_XovGnkJbJyhJheOMCyVdPHXiVSFYzg7LWmh3J1NdJdRcGg7x-041dMY7AMVHQe0%3D&hl=en-US&gl=us&fo_m=MfohQo559jFvMUOzJVpjPL1YMfZ3bInYwBDuMfaXTPp5KXh-&utm_source=tactile&gei=8ZJuZr3mO7H9ptQP2eqTqA0&ei=8ZJuZr3mO7H9ptQP2eqTqA0&fo_s=OA,SOE&opi=79508299&foub=mcpp', 
        'thumbnail': 'https://lh5.googleusercontent.com/p/AF1QipMccUDA0KNb8P7MiZqUTXdLSLDkou-vBARn0pHE=w138-h92-k-no'
    }, 
    {
        'position': 4, 
        'title': 'Famous $1.50 pizza', 
        'place_id': 'ChIJCf55rwdZwokRWehZElNpkOE', 
        'data_id': '0x89c25907af79fe09:0xe19069531259e859', 
        'data_cid': '16253606860691204185', 
        'reviews_link': 'https://serpapi.com/search.json?data_id=0x89c25907af79fe09%3A0xe19069531259e859&engine=google_maps_reviews&hl=en', 
        'photos_link': 'https://serpapi.com/search.json?data_id=0x89c25907af79fe09%3A0xe19069531259e859&engine=google_maps_photos&hl=en', 
        'gps_coordinates': {'latitude': 40.7582196, 'longitude': -73.992582}, 
        'place_id_search': 'https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJCf55rwdZwokRWehZElNpkOE', 
        'provider_id': '/g/11sbr7gb31', 
        'rating': 3.7, 
        'reviews': 35, 
        'price': '$', 
        'type': 'Pizza restaurant', 
        'types': ['Pizza restaurant', 'Chicken wings restaurant', 'Hamburger restaurant', 'Hot dog restaurant'], 
        'type_id': 'pizza_restaurant', 
        'type_ids': ['pizza_restaurant', 'chicken_wings_restaurant', 'hamburger_restaurant', 'hot_dog_restaurant'], 
        'address': '578 9th Ave, New York, NY 10036', 
        'open_state': 'Closes soon ⋅ 3:30\u202fAM ⋅ Reopens 10\u202fAM', 
        'hours': 'Closes soon ⋅ 3:30\u202fAM ⋅ Reopens 10\u202fAM', 
        'operating_hours': {'saturday': '10\u202fAM–3:30\u202fAM', 'sunday': '10\u202fAM–3:30\u202fAM', 'monday': '10\u202fAM–3:30\u202fAM', 'tuesday': '10\u202fAM–3:30\u202fAM', 'wednesday': '10\u202fAM–3:30\u202fAM', 'thursday': '10\u202fAM–3:30\u202fAM', 'friday': '10\u202fAM–3:30\u202fAM'}, 
        'website': 'https://www.famouspizzaofnewyork.com/', 
        'service_options': {'dine_in': True, 'curbside_pickup': True, 'no_contact_delivery': True}, 
        'order_online': 'https://food.google.com/chooseprovider?restaurantId=/g/11sbr7gb31&g2lbs=AOHF13k4n7FR7WiUf26LHinrHqB5BxLnVBS3Q9lIMPuDnXxKuONyizAy5-jweGlKrxfsAZBmcwu-kreQmbcnV2JGwC7vCvz2sJoRv8hIdsR1D80A2l0numM%3D&hl=en-US&gl=us&fo_m=MfohQo559jFvMUOzJVpjPL1YMfZ3bInYwBDuMfaXTPp5KXh-&utm_source=tactile&gei=8ZJuZr3mO7H9ptQP2eqTqA0&ei=8ZJuZr3mO7H9ptQP2eqTqA0&fo_s=OA,SOE&opi=79508299&foub=mcpp', 
        'thumbnail': 'https://lh5.googleusercontent.com/p/AF1QipNHzC5jTRd9MMcRv0Clpg21yWcZ6zn2UHfWfxXu=w80-h106-k-no'
    }, 
    {
        'position': 5, 
        'title': 'ANDIAMO PIZZA', 
        'place_id': 'ChIJvxSJw4VZwokRI_KM0rv6Ths', 
        'data_id': '0x89c25985c38914bf:0x1b4efabbd28cf223', 
        'data_cid': '1967785771805766179', 
        'reviews_link': 'https://serpapi.com/search.json?data_id=0x89c25985c38914bf%3A0x1b4efabbd28cf223&engine=google_maps_reviews&hl=en', 
        'photos_link': 'https://serpapi.com/search.json?data_id=0x89c25985c38914bf%3A0x1b4efabbd28cf223&engine=google_maps_photos&hl=en', 
        'gps_coordinates': {'latitude': 40.7461489, 'longitude': -73.9902178}, 
        'place_id_search': 'https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJvxSJw4VZwokRI_KM0rv6Ths', 
        'provider_id': '/g/11rq954kyb', 
        'rating': 4.7, 
        'reviews': 696, 
        'price': '$$', 
        'type': 'Pizza restaurant', 
        'types': ['Pizza restaurant'], 
        'type_id': 'pizza_restaurant', 
        'type_ids': ['pizza_restaurant'], 
        'address': '818 6th Ave, New York, NY 10001', 
        'open_state': 'Open ⋅ Closes 5\u202fAM ⋅ Reopens 10\u202fAM', 'hours': 'Open ⋅ Closes 5\u202fAM ⋅ Reopens 10\u202fAM', 
        'operating_hours': {'saturday': '9\u202fAM–5\u202fAM', 'sunday': '10\u202fAM–4\u202fAM', 'monday': '9\u202fAM–4\u202fAM', 'tuesday': '9\u202fAM–4\u202fAM', 'wednesday': '9\u202fAM–4\u202fAM', 'thursday': '9\u202fAM–4\u202fAM', 'friday': '9\u202fAM–5\u202fAM'}, 
        'phone': '(212) 254-2860', 
        'website': 'https://www.andiamopizzamenu.com/?utm_source=gbp', 
        'description': 'Simple Italian joint, open late. Italian classics in a straightforward, family-operated counter-serve with late-night hours.', 
        'service_options': {'dine_in': True, 'takeout': True, 'no_contact_delivery': True}, 
        'order_online': 'https://food.google.com/chooseprovider?restaurantId=/g/11rq954kyb&g2lbs=AOHF13no2CagSv61bGt0TCGCH6hUqqZ3E9vc96jrts864IEp4HErku-H-CGxcI6zD-8xHbsgXjOsorVld2ZLU2MiayfoVGDOB_2naCW2DDzZ-Y3mlKNvQlE%3D&hl=en-US&gl=us&fo_m=MfohQo559jFvMUOzJVpjPL1YMfZ3bInYwBDuMfaXTPp5KXh-&utm_source=tactile&gei=8ZJuZr3mO7H9ptQP2eqTqA0&ei=8ZJuZr3mO7H9ptQP2eqTqA0&fo_s=OA,SOE&opi=79508299&foub=mcpp', 
        'thumbnail': 'https://lh5.googleusercontent.com/p/AF1QipPJ-WuydhtN
    }
]




[
    {
        "position": 1,
        "title": "Villa of the birds",
        "place_id": "ChIJC6DRIQPD9RQRDb-0semWxqw",
        "data_id": "0x14f5c30321d1a00b:0xacc696e9b1b4bf0d",
        "data_cid": "12449804150365273869",
        "reviews_link": "https://serpapi.com/search.json?data_id=0x14f5c30321d1a00b%3A0xacc696e9b1b4bf0d&engine=google_maps_reviews&hl=en",
        "photos_link": "https://serpapi.com/search.json?data_id=0x14f5c30321d1a00b%3A0xacc696e9b1b4bf0d&engine=google_maps_photos&hl=en",
        "gps_coordinates": {
            "latitude": 31.1954085,
            "longitude": 29.9053826
        },
        "place_id_search": "https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJC6DRIQPD9RQRDb-0semWxqw",
        "provider_id": "/g/11r4rs3pms",
        "rating": 4.6,
        "reviews": 11,
        "unclaimed_listing": true,
        "type": "Tourist attraction",
        "types": ["Tourist attraction"],
        "type_id": "tourist_attraction",
        "type_ids": ["tourist_attraction"],
        "address": "54 شارع صفية زغلول،, Al Mesallah Sharq, Al Attarin, Alexandria Governorate, Egypt",
        "thumbnail": "https://lh5.googleusercontent.com/p/AF1QipP53nE-9nYRlV6nj5mce7tHdtEZWDHoL0njriUu=w122-h92-k-no"
    },
    {
        "position": 2,
        "title": "Alexandria National Museum",
        "place_id": "ChIJXQFL_Y7D9RQRmwOz6ziv66I",
        "data_id": "0x14f5c38efd4b015d:0xa2ebaf38ebb3039b",
        "data_cid": "11739669512678736795",
        "reviews_link": "https://serpapi.com/search.json?data_id=0x14f5c38efd4b015d%3A0xa2ebaf38ebb3039b&engine=google_maps_reviews&hl=en",
        "photos_link": "https://serpapi.com/search.json?data_id=0x14f5c38efd4b015d%3A0xa2ebaf38ebb3039b&engine=google_maps_photos&hl=en",
        "gps_coordinates": {
            "latitude": 31.2007415,
            "longitude": 29.9131977
        },
        "place_id_search": "https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJXQFL_Y7D9RQRmwOz6ziv66I",
        "provider_id": "/m/04n2r_v",
        "rating": 4.4,
        "reviews": 2657,
        "type": "Tourist attraction",
        "types": ["Tourist attraction", "Museum", "National museum", "Archaeological museum"],
        "type_id": "tourist_attraction",
        "type_ids": ["tourist_attraction", "museum", "national_museum", "archaeological_museum"],
        "address": "131 El-Shaheed Galal El-Desouky, Bab Sharqi WA Wabour Al Meyah, Bab Sharqi, Alexandria Governorate 5423004, Egypt",
        "open_state": "Open ⋅ Closes 4:30\u202fPM",
        "hours": "Open ⋅ Closes 4:30\u202fPM",
        "operating_hours": {
            "sunday": "9\u202fAM–4:30\u202fPM",
            "monday": "9\u202fAM–4:30\u202fPM",
            "tuesday": "9\u202fAM–4:30\u202fPM",
            "wednesday": "9\u202fAM–4:30\u202fPM",
            "thursday": "9\u202fAM–4:30\u202fPM",
            "friday": "9\u202fAM–4:30\u202fPM",
            "saturday": "9\u202fAM–4:30\u202fPM"
        },
        "phone": "+20 3 4835519",
        "website": "http://www.alexandria.gov.eg/services/tourism/alextourism/museums/alexmusuem.html",
        "description": "Egyptian history in an Italianate palace. Restored Italianate palace offering exhibits & artifacts exploring Egypt's history through the ages.",
        "user_review": "Amazing place totally recommend for those attracted to historic monuments",
        "thumbnail": "https://lh5.googleusercontent.com/p/AF1QipOi230MllN-qfPqsVuN5qHVtSNw_RftXuA0wVDB=w163-h92-k-no"
    },
    {
        "position": 3,
        "title": "Serapeum of Alexandria",
        "place_id": "ChIJVUwIosXD9RQRmZKCQYexAbo",
        "data_id": "0x14f5c3c5a2084c55:0xba01b18741829299",
        "data_cid": "13403189160509084313",
        "reviews_link": "https://serpapi.com/search.json?data_id=0x14f5c3c5a2084c55%3A0xba01b18741829299&engine=google_maps_reviews&hl=en",
        "photos_link": "https://serpapi.com/search.json?data_id=0x14f5c3c5a2084c55%3A0xba01b18741829299&engine=google_maps_photos&hl=en",
        "gps_coordinates": {
            "latitude": 31.1823466,
            "longitude": 29.8962872
        },
        "place_id_search": "https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJVUwIosXD9RQRmZKCQYexAbo",
        "provider_id": "/m/0c3zzfp",
        "rating": 4.4,
        "reviews": 7491,
        "type": "Tourist attraction",
        "types": ["Tourist attraction", "Historical landmark"],
        "type_id": "tourist_attraction",
        "type_ids": ["tourist_attraction", "historical_landmark"],
        "address": "Pompey's Pillar, Al Karah WA at Toubageyah WA Kafr Al Ghates, Karmouz, Alexandria Governorate 5341142, Egypt",
        "open_state": "Open ⋅ Closes 4:30\u202fPM",
        "hours": "Open ⋅ Closes 4:30\u202fPM",
        "operating_hours": {
            "sunday": "9\u202fAM–4:30\u202fPM",
            "monday": "9\u202fAM–4:30\u202fPM",
            "tuesday": "9\u202fAM–4:30\u202fPM",
            "wednesday": "9\u202fAM–4:30\u202fPM",
            "thursday": "9\u202fAM–4:30\u202fPM",
            "friday": "9\u202fAM–4:30\u202fPM",
            "saturday": "9\u202fAM–4:30\u202fPM"
        },
        "phone": "+20 12 29437357",
        "description": "Iconic Roman-era granite column. This famous Roman-era red-granite column with sphinxes was once part of the Serapeum temple.",
        "user_review": "The main attraction is of course the pillar.",
        "thumbnail": "https://lh5.googleusercontent.com/p/AF1QipPEypYs6CrgJMO7nhGM8rdaGoW4Gr8qPE7pMTTz=w122-h92-k-no"
    },
    {
        "position": 4,
        "title": "Royal Jewelry Museum, Alexandria",
        "place_id": "ChIJy_MpOynF9RQRd0iVR1mVkPc",
        "data_id": "0x14f5c5293b29f3cb:0xf790955947954877",
        "data_cid": "17838922334700128375",
        "reviews_link": "https://serpapi.com/search.json?data_id=0x14f5c5293b29f3cb%3A0xf790955947954877&engine=google_maps_reviews&hl=en",
        "photos_link": "https://serpapi.com/search.json?data_id=0x14f5c5293b29f3cb%3A0xf790955947954877&engine=google_maps_photos&hl=en",
        "gps_coordinates": {
            "latitude": 31.2452911,
            "longitude": 29.9637522
        },
        "place_id_search": "https://serpapi.com/search.json?engine=google_maps&google_domain=google.com&hl=en&place_id=ChIJy_MpOynF9RQRd0iVR1mVkPc",
        "rating": 4.7,
        "reviews": 2211,
        "type": "Tourist attraction",
        "types": ["Tourist attraction", "Museum"],
        "type_id": "tourist_attraction",
        "type_ids": ["tourist_attraction", "museum"],
        "address": "27 Ahmed Yehia Street, Alexandria, Egypt",
        "open_state": "Open ⋅ Closes 5\u202fPM",
        "hours": "Open ⋅ Closes 5\u202fPM",
        "operating_hours": {
            "sunday": "9\u202fAM–5\u202fPM",
            "monday": "9\u202fAM–5\u202fPM",
            "tuesday": "9\u202fAM–5\u202fPM",
            "wednesday": "9\u202fAM–5\u202fPM",
            "thursday": "9\u202fAM–5\u202fPM",
            "friday": "9\u202fAM–5\u202fPM",
            "saturday": "9\u202fAM–5\u202fPM"
        },
        "phone": "+20 3 5828348",
        "description": "Elegant museum showcasing royal jewelry. Regal museum showcasing elaborate, antique jewelery & ornate glassware in a regal palace setting.",
        "thumbnail": "https://lh5.googleusercontent.com/p/AF1QipPoS5h7WMeTVql-7uRd06wLkhZYH_QmtMd4_M1c=w122-h92-k-no"
    }
]

'''