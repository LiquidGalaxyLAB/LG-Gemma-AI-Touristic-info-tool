import 'dart:async';
import 'dart:convert';
import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:ai_touristic_info_tool/services/geocoding_services.dart';
import 'package:async/async.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

///This is the [Api] class that contains all kind of requests we might need

class Api {
  final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

  // Method to check server availability
  Future<bool> _isServerAvailable(String url) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  CancelableOperation? _cancelableOperation;

//Not implemented correctly
  Future<dynamic> postInvokeGemma({required String input}) async {
    if (baseUrl == 'None') {
      throw Exception('Gemma is not accessible through any server right now');
    }
    //final url = Uri.parse('$baseUrl$endpoint');
    final url = Uri.parse('http://10.0.2.2:8000/rag/invoke');

    if (!await _isServerAvailable(url.toString())) {
      return Future.error(
          'The server is currently unavailable. Please try again later.');
    }

    final body = json.encode({'input': input});
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final responseJson = data;
        print('inside invoke gemma');
        print(responseJson);
        print(responseJson['output']['places'][0]['name']); //should be a list
        return {'response': responseJson};
      } else {
        return Future.error(
            'There is a problem with status code ${response.statusCode}.');
      }
    } catch (e) {
      return Future.error('An error occurred: $e');
    }
  }

  Stream<dynamic> postaStreamEventsGemma({required String input}) async* {
    final http.Client _client = http.Client();
    final rag_url = Uri.parse('http://10.0.2.2:8000/rag/stream_events');

    final rag_headers = {
      'Content-Type': 'application/json',
      'accept': 'text/event-stream',
    };
    final rag_body = json.encode({'input': input});
    final request = http.Request('POST', rag_url)
      ..headers.addAll(rag_headers)
      ..body = rag_body;

    if (!await _isServerAvailable(rag_url.toString())) {
      print('not available');
      yield {
        'type': 'error',
        'data': 'The server is currently unavailable. Please try again later.'
      };
      return;
    }

    /*
       curl -X POST "http://localhost:3000/rag/stream_events" -d '{"input": "Tinputks World Wide"}'
      */

    //final response = await http.post(url, headers: headers, body: body);

    final rag_response = await _client.send(request);
    final stream = rag_response.stream;
    _cancelableOperation =
        CancelableOperation.fromFuture(_client.send(request));

    Map<String, dynamic> outputStrJson;
    List<PlacesModel> pois = [];
    try {
      await for (var event
          in stream.transform(utf8.decoder).transform(LineSplitter())) {
        if (_cancelableOperation!.isCanceled) {
          _client.close();
          yield {'type': 'error', 'data': 'Operation cancelled.'};
          return;
        }

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

  // Method to cancel the current operation
  void cancelOperation() {
    _cancelableOperation?.cancel();
  }
}
