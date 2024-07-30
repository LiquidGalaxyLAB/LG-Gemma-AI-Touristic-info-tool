import 'dart:async';
import 'dart:convert';
import 'package:ai_touristic_info_tool/helpers/lg_connection_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

///This is the [Api] class that contains all kind of requests we might need

class Api {
  //final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

  String baseUrl =
      'http://${LgConnectionSharedPref.getAiIp() ?? ''}:${LgConnectionSharedPref.getAiPort() ?? ''}';

  Future<String> isEndpointAvailable() async {
    final url = '$baseUrl/health';
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 200));
      if (response.statusCode == 200) {
        return 'Success';
      } else {
        return 'Error occurred while trying to connect to the server. Status code: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error occurred while trying to connect to the server: $e';
    }
  }

  // Method to check server availability
  Future<bool> isServerAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Stream<dynamic> postaStreamEventsGemma({required String input}) async* {
    final http.Client _client = http.Client();
    //final rag_url = Uri.parse('http://10.0.2.2:8000/rag/stream_events');
    final rag_url = Uri.parse('$baseUrl/rag/stream_events');
    final rag_headers = {
      'Content-Type': 'application/json',
      'accept': 'text/event-stream',
    };
    final rag_body = json.encode({'input': input});
    final request = http.Request('POST', rag_url)
      ..headers.addAll(rag_headers)
      ..body = rag_body;

    if (!await isServerAvailable()) {
      print('not available');
      yield {
        'type': 'error',
        'data': 'The server is currently unavailable. Please try again later.'
      };
      return;
    }

    /*
       curl -X GET "http://localhost:3000/health" 
      */

    //final response = await http.post(url, headers: headers, body: body);

    final rag_response = await _client.send(request);
    final stream = rag_response.stream;

    Map<String, dynamic> outputStrJson;
    List<PlacesModel> pois = [];
    try {
      await for (var event
          in stream.transform(utf8.decoder).transform(LineSplitter())) {
        print('Whole Event');
        print(event);
        if (event.startsWith('data: ')) {
          String jsonData = event.substring(6);
          Map<String, dynamic> jsonMap = jsonDecode(jsonData);
          print(jsonMap);
          print(jsonMap['event']);
          String chunk = '';
          if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_chain_start') {
            yield {
              'type': 'message',
              'data': "RAG (Retrieval Augmented Generation) Chain Starting ..."
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_retriever_start') {
            yield {'type': 'message', 'data': "Getting Retrieval ready..."};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_retriever_end') {
            yield {'type': 'message', 'data': "Retrieval Initialized ..."};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_prompt_start') {
            yield {'type': 'message', 'data': "Preparing Prompt ..."};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_prompt_end') {
            yield {'type': 'message', 'data': "Prompt Ready ..."};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_start') {
            yield {
              'type': 'message',
              'data': "Getting Gemma LLM Model ready..."
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_stream') {
            chunk = jsonMap['data']['chunk'];
            yield {'type': 'chunk', 'data': chunk};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_end') {
            yield {'type': 'message', 'data': "End of Chain ..."};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_chain_end' &&
              jsonMap['name'] == '/rag') {
            // the output
            outputStrJson = jsonMap['data']['output'];
            List<dynamic> places = outputStrJson['places'];
            for (int i = 0; i < places.length; i++) {
              Map<String, dynamic> place = places[i];
              String location =
                  '${place['name']}, ${place['address']}, ${place['city']}, ${place['country']}';
              MyLatLng latlng =
                  await GeocodingService().getCoordinates(location);
              PlacesModel poi = PlacesModel(
                id: i + 1,
                name: place['name'],
                description: place['description'],
                address: place['address'],
                city: place['city'],
                country: place['country'],
                ratings: place['ratings'],
                amenities: place['reviews'],
                price: place['price'],
                sourceLink: place['sourceLink'],
                latitude: latlng.latitude,
                longitude: latlng.longitude,
              );
              pois.add(poi);
            }
            yield {'type': 'result', 'data': pois};
          }
        }
      }
    } catch (e) {
      yield {
        'type': 'error',
        'data': 'An error occurred while generating the response: $e'
      };
    } finally {
      _client.close();
    }
  }

  Future<List<String>> fetchWebUrls(String placeName) async {
    final Uri uri = Uri.parse('$baseUrl/search?place_name=$placeName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<String>();
    } else {
      throw Exception('Failed to fetch URLs: ${response.reasonPhrase}');
    }
  }

  Future<List<String>> fetchYoutubeUrls({required String query}) async {
    final String endpoint = 'https://www.googleapis.com/youtube/v3/search';

    final Uri url = Uri.parse(
        '$endpoint?key=${dotenv.env['YOUTUBE_API_KEY']}&q=$query&type=video');

    final response = await http.get(url);

    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> videoUrls = [];

      for (var item in data['items']) {
        String videoId = item['id']['videoId'];
        String videoUrl = 'https://www.youtube.com/watch?v=$videoId';
        videoUrls.add(videoUrl);
      }

      return videoUrls;
    } else {
      throw Exception('Failed to load YouTube URLs');
    }
  }

  Future<void> cancelOperation() async {
    final url = Uri.parse('$baseUrl/cancel_task');

    if (!await isServerAvailable()) {
      print('not available');
      return;
    }
    var response = await http.post(url);
    print(response.body);
  }

  /*
  {
    "kind": "youtube#searchListResponse",
    "etag": "Zst6lwOypE4DBtSPVw6tuGyftAQ",
    "nextPageToken": "CAUQAA",
    "regionCode": "EG",
    "pageInfo": {
        "totalResults": 1000000,
        "resultsPerPage": 5
    },
    "items": [
        {
            "kind": "youtube#searchResult",
            "etag": "UavMxCzNwTBKvDvz6Lw4LyzqULY",
            "id": {
                "kind": "youtube#video",
                "videoId": "wqslA_CKub8"
            }
        },
        {
            "kind": "youtube#searchResult",
            "etag": "hFNgNyr0lUJM_d0awLOrb5wR0cc",
            "id": {
                "kind": "youtube#video",
                "videoId": "H3xgBS_kDNw"
            }
        },
        {
            "kind": "youtube#searchResult",
            "etag": "xohIkR4Y5le4a7DluNhpG_FgBjI",
            "id": {
                "kind": "youtube#video",
                "videoId": "TVLYtiunWJA"
            }
        },
        {
            "kind": "youtube#searchResult",
            "etag": "1HI7A5_rlCvYMpz-d-XDMvgOZQE",
            "id": {
                "kind": "youtube#video",
                "videoId": "inD5GnTjs_E"
            }
        },
        {
            "kind": "youtube#searchResult",
            "etag": "NvW-WEQ39cZWQ9tlHJaS6HiJFPQ",
            "id": {
                "kind": "youtube#video",
                "videoId": "J6Jo8hHsFXA"
            }
        }
    ]
}
  */
}
