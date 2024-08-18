import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_touristic_info_tool/helpers/lg_connection_shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// A service class for handling text-to-speech and speech-to-text operations using a remote API.
class VoicesServicesApi {

  /// The base URL for the API, constructed using the voice IP and port retrieved from shared preferences.
   String baseUrl =
      'http://${LgConnectionSharedPref.getVoiceIp() ?? ''}:${LgConnectionSharedPref.getVoicePort() ?? ''}';
      

  /// Converts text to speech using an API.
  ///
  /// Sends a POST request to the text-to-speech API with the provided [text],
  /// and saves the resulting audio file in the application's documents directory.
  ///
  /// Returns a [File] containing the audio data if successful, or `null` if an error occurs.
  ///
  /// Throws a [TimeoutException] if the request takes longer than 10 seconds indicating an error.
  Future<File?> textToSpeech(String text) async {
    // final url = Uri.parse('http://10.0.2.2:8440/text-to-speech');
    final url= Uri.parse('$baseUrl/text-to-speech');

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

  /// Converts speech to text using an API.
  ///
  /// Sends a POST request to the speech-to-text API with the provided [content] audio file.
  ///
  /// Returns a [String] containing the transcribed text if successful, or 'Failed' if an error occurs.
  ///
  /// The function uses multipart/form-data to send the audio file.
  Future<String> speechToTextApi(File content) async {
    // final uri = Uri.parse("http://10.0.2.2:8440/speech-to-text");
     final uri= Uri.parse('$baseUrl/speech-to-text');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = 'multipart/form-data';

    request.files.add(await http.MultipartFile.fromPath('audio', content.path));
    request.fields['model'] = 'deepgram_stt';
    request.fields['deepgram_model'] = 'aura-helios-en';

    try {
      final response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 307) {
        print("API Call Successful");
        final responseBody = await response.stream.bytesToString();
        return responseBody;
      } else {
        print("Failed to call API: ${response.statusCode}");
        return 'Failed';
      }
    } catch (e) {
      print('Error: $e');
      return 'Failed';
    }
  }
}
