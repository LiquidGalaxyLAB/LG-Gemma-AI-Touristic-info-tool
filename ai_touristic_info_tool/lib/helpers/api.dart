import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

///This is the [Api] class that contains all kind of requests we might need

class Api {
  final String baseUrl = dotenv.env['GEMMA_IP_Server'] ?? 'None';

  Future<dynamic> get({required String url, @required String? token}) async {
    Map<String, String> headers = {};

    if (baseUrl == 'None') {
      throw Exception('Gemma is not accessible through any server right now');
    }

    if (token != null) {
      headers.addAll({'Authorization': ' $token'});
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode}');
    }
  }

  Future<dynamic> postGemma(
      {required String endpoint, required dynamic body}) async {
    if (baseUrl == 'None') {
      throw Exception('Gemma is not accessible through any server right now');
    }
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final responseJson = data;
      return {'response': responseJson};
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode} with body ${jsonDecode(response.body)}');
    }
  }
}
