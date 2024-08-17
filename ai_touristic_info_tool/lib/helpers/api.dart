import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ai_touristic_info_tool/helpers/lg_connection_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

///This is the [Api] class that contains all kind of requests we might need

class Api {
  //final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

  String baseUrl =
      'http://${LgConnectionSharedPref.getAiIp() ?? ''}:${LgConnectionSharedPref.getAiPort() ?? ''}';

  Future<String> isEndpointAvailable(BuildContext context) async {
    final url = '$baseUrl/health';
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 200));
      if (response.statusCode == 200) {
        // return 'Success';
        return AppLocalizations.of(context)!.defaults_success;
      } else {
        // return 'Error occurred while trying to connect to the server. Status code: ${response.statusCode}';
        return AppLocalizations.of(context)!
            .aiGenerationAPIGemma_errorresponse1(response.statusCode);
      }
    } catch (e) {
      // return 'Error occurred while trying to connect to the server: $e';
      return AppLocalizations.of(context)!
          .aiGenerationAPIGemma_errorresponse2(e.toString());
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

  Stream<dynamic> postaStreamEventsGemma(BuildContext context,
      {required String input}) async* {
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
        // 'data': 'The server is currently unavailable. Please try again later.'
        'data': AppLocalizations.of(context)!
            .aiGenerationAPIGemma_serverNotAvailable
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
              // 'data': "RAG (Retrieval Augmented Generation) Chain Starting ..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages1
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_retriever_start') {
            yield {
              'type': 'message',
              // 'data': "Getting Retrieval ready..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages2
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_retriever_end') {
            yield {
              'type': 'message',
              // 'data': "Retrieval Initialized ..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages3
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_prompt_start') {
            yield {
              'type': 'message',
              // 'data': "Preparing Prompt ..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages4
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_prompt_end') {
            yield {
              'type': 'message',
              //  'data': "Prompt Ready ..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages5
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_start') {
            yield {
              'type': 'message',
              // 'data': "Getting Gemma LLM Model ready..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages6
            };
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_stream') {
            chunk = jsonMap['data']['chunk'];
            yield {'type': 'chunk', 'data': chunk};
          } else if (jsonMap.containsKey('event') &&
              jsonMap['event'] == 'on_llm_end') {
            yield {
              'type': 'message',
              // 'data': "End of Chain ..."
              'data': AppLocalizations.of(context)!
                  .aiGenerationAPIGemma_progressMessages7
            };
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
        // 'data': 'An error occurred while generating the response: $e'
        'data': AppLocalizations.of(context)!
            .aiGenerationAPIGemma_errorresponsegeneration(e.toString())
      };
    } finally {
      _client.close();
    }
  }

  Future<List<String>> fetchWebUrls(
      String placeName, BuildContext context) async {
    final Uri uri = Uri.parse('$baseUrl/search?place_name=$placeName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<String>();
    } else {
      // throw Exception('Failed to fetch URLs: ${response.reasonPhrase}');
      throw Exception(AppLocalizations.of(context)!
          .aiGenerationAPIGemma_errorFetchURLs(
              response.reasonPhrase.toString()));
    }
  }

  Future<List<String>> fetchYoutubeUrls(BuildContext context,
      {required String query}) async {
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
      // throw Exception('Failed to load YouTube URLs');
      throw Exception(
          AppLocalizations.of(context)!.aiGenerationAPIGemma_errorFetchYoutube);
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

  Future<File?> textToSpeech(String text) async {
    final url = Uri.parse('http://10.0.2.2:8440/text-to-speech');
    /*
  curl -X POST -H "Content-Type: application/json" -d '{"model":"deepgram_tts", "content":"Hello how are you today. I am your personal assistant"}' http://localhost:8440/text-to-speech

  */
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(
        {'model': 'deepgram_tts', 'content': text, "voice": "aura-helios-en"});

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: 10));
      ;
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audio.wav';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        // throw Exception('Failed to convert text to speech');
        print('Failed to convert text to speech');
        return null;
      }
    } on TimeoutException catch (_) {
      print('Request to text-to-speech API timed out');
      return null;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String> speechToTextApi(File content) async {
    final uri = Uri.parse("http://10.0.2.2:8440/speech-to-text");
    //adding headers:

    final request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = 'multipart/form-data';

    request.files.add(await http.MultipartFile.fromPath('audio', content.path));
    request.fields['model'] = 'deepgram_stt';
    request.fields['deepgram_model'] = 'aura-helios-en';

    try {
      final response = await request.send();

      print('response');
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 307) {
        print("API Call Successful");
        final responseBody = await response.stream.bytesToString();
        print('responseBody');
        print(responseBody);
        return responseBody;
      } else {
        print("Failed to call API: ${response.statusCode}");
        // throw Exception('Failed to load data');
        return 'Failed';
      }
    } catch (e) {
      print('Error: $e');
      return 'Failed';
    }
  }
}


/*

Future<void> uploadFile(File file) async {
  final uri = Uri.parse('https://example.com/upload');
  
  // Create a MultipartRequest
  final request = http.MultipartRequest('POST', uri);
  
  // Attach the file
  request.files.add(await http.MultipartFile.fromPath('file', file.path));
  
  // Optionally add other fields
  request.fields['description'] = 'File upload example';
  
  try {
    // Send the request
    final response = await request.send();
    
    // Check the response status
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

*/