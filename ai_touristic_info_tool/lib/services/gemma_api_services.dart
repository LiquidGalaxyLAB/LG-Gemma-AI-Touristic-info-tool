import 'dart:convert';

import 'package:ai_touristic_info_tool/helpers/lg_connection_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

/// A service class that interacts with the Gemma AI API.
/// It provides methods for health checks, generating responses from the API, and fetching URLs related to specific places.
class GemmaApiServices {

  /// Base URL for the Gemma API.
  /// It dynamically constructs the URL using the IP and port stored in shared preferences.
  String baseUrl =
      'http://${LgConnectionSharedPref.getAiIp() ?? ''}:${LgConnectionSharedPref.getAiPort() ?? ''}';

  /// Checks if the Gemma API endpoint is available.
  /// Returns a localized success message if the endpoint is reachable, or an error message if not.
  /// 
  /// [context]: The BuildContext used for localization.
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

  /// Checks if the Gemma API server is available.
  /// Returns `true` if the server responds with a status code of 200, `false` otherwise.
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

  /// Sends a POST request to the Gemma API's RAG endpoint 
  /// to generate events in a stream and yields the results as a stream of responses.
  ///
  /// [context]: The BuildContext used for localization.
  /// [input]: The input string to be sent to the API.
  /// 
  /// Yields different types of messages and results as the API processes the request in a stream mode.
  Stream<dynamic> postaStreamEventsGemma(BuildContext context,
      {required String input}) async* {
    final http.Client _client = http.Client();
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
      yield {
        'type': 'error',
        // 'data': 'The server is currently unavailable. Please try again later.'
        'data': AppLocalizations.of(context)!
            .aiGenerationAPIGemma_serverNotAvailable
      };
      return;
    }

    final rag_response = await _client.send(request);
    final stream = rag_response.stream;

    Map<String, dynamic> outputStrJson;
    List<PlacesModel> pois = [];
    try {
      await for (var event
          in stream.transform(utf8.decoder).transform(LineSplitter())) {
        if (event.startsWith('data: ')) {
          String jsonData = event.substring(6);
          Map<String, dynamic> jsonMap = jsonDecode(jsonData);
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

  /// Fetches a list of URLs related to the specified place name from the Gemma API.
  ///
  /// [placeName]: The name of the place to search for.
  /// [context]: The BuildContext used for localization.
  ///
  /// Returns a list of URLs as a List of Strings.
  Future<List<String>> fetchWebUrlsWithGemma(
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

  // Future<void> cancelOperation() async {
  //   final url = Uri.parse('$baseUrl/cancel_task');

  //   if (!await isServerAvailable()) {
  //     return;
  //   }
  //   var response = await http.post(url);
  // }
}
