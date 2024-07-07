import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

///This is the [Api] class that contains all kind of requests we might need

class Api {
  final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

  Future<dynamic> postGemma(
      {required String endpoint, required String input}) async {
    if (baseUrl == 'None') {
      throw Exception('Gemma is not accessible through any server right now');
    }
    //final url = Uri.parse('$baseUrl$endpoint');
    final url = Uri.parse('http://10.0.2.2:3000/rag/invoke');
    final body = json.encode({'input': input});
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final responseJson = data;
      print(responseJson);
      print(responseJson['output']['places'][0].name); //should be a list
      return {'response': responseJson};
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode} with body ${jsonDecode(response.body)}');
    }
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

///This is the [Api] class that contains all kind of requests we might need
// class Api {
//   final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

//   Future<void> postGemmaStream({
//     required String endpoint,
//     required String input,
//     required void Function(String) onData,
//     required void Function() onDone,
//     required void Function(dynamic) onError,
//   }) async {
//     if (baseUrl == 'None') {
//       throw Exception('Gemma is not accessible through any server right now');
//     }
//     //final url = Uri.parse('$baseUrl/$endpoint');
//     final url = Uri.parse('http://10.0.2.2:3000/rag/stream_events');
//     final body = json.encode({'input': input});

//     final request = http.Request('POST', url)
//       ..headers.addAll({'Content-Type': 'application/json'})
//       ..body = body;

//     final response = await http.Client().send(request);

//     final subscription = response.stream.transform(utf8.decoder).listen(onData);
//     subscription.onDone(onDone);
//     subscription.onError(onError);
//   }
// }
