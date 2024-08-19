import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'dart:math';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A service class for fetching URLs related to user queries, including YouTube video URLs and general URLs from Google search results
class SearchServices {
  /// Fetches a list of YouTube video URLs based on the provided search query.
  ///
  /// The function uses the YouTube Data API to search for videos related to the query.
  ///
  /// [context]: The BuildContext used to retrieve localization strings.
  /// [query]: The search query string.
  /// Returns a list of YouTube video URLs.
  /// Throws an exception if the API request fails.
  Future<List<String>> fetchYoutubeUrls(BuildContext context, String apiKey,
      {required String query}) async {
    final String endpoint = 'https://www.googleapis.com/youtube/v3/search';

    final Uri url = Uri.parse('$endpoint?key=$apiKey&q=$query&type=video');
    // final Uri url = Uri.parse(
    //     '$endpoint?key=${dotenv.env['YOUTUBE_API_KEY']}&q=$query&type=video');
    try {
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
        // throw Exception(
        //     AppLocalizations.of(context)!.aiGenerationAPIGemma_errorFetchYoutube);
        return [];
      }
    } catch (e) {
      return [];
      // throw Exception(
      //     AppLocalizations.of(context)!.aiGenerationAPIGemma_errorFetchYoutube);
    }
  }

  /// Fetches a list of URLs from Google search results based on the provided term.
  ///
  /// The function scrapes Google search results to extract URLs related to the search term.
  ///
  /// [term]: The search term used to find related URLs.
  /// [numResults]: The maximum number of URLs to fetch (default is 40).
  /// [lang]: The language for the search results (default is 'en').
  /// [sleepInterval]: The duration to wait between consecutive search requests (optional).
  /// [timeout]: The timeout duration for each HTTP request (optional).
  /// [safe]: The safe search setting (optional).
  /// [region]: The region code to localize the search results (optional).
  /// Returns a list of URLs related to the search term.
  Future<List<String>> fetchUrls(
    // BuildContext context,
    String term, {
    int numResults = 40,
    String lang = 'en',
    Duration? sleepInterval,
    Duration? timeout,
    String? safe = 'active',
    String? region,
  }) async {
    const _userAgentList = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1',
      'Mozilla/5.0 (Linux; Android 13; SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:115.0) Gecko/20100101 Firefox/115.0'
    ];

    final results = <String>[];
    int start = 0;
    int fetchedResults = 0;

    final client = http.Client();
    final random = Random();

    while (fetchedResults < numResults) {
      final uri = Uri.https(
        'www.google.com',
        '/search',
        {
          'q': '$term -tripadvisor -inurl:http',
          'num': '${numResults + 2}',
          'hl': lang,
          'start': '$start',
          'safe': safe,
          'gl': region,
        },
      );

      final response = await client.get(
        uri,
        headers: {
          'User-Agent': _userAgentList[random.nextInt(_userAgentList.length)],
        },
      ).timeout(timeout ?? const Duration(seconds: 60));

      print('response code: ${response.statusCode}');

      if (response.statusCode != 200) {
        if (response.statusCode == 429) {
          return [];
        } else {
          continue;
        }
      }

      final soup = BeautifulSoup(response.body);
      soup.findAll('style').forEach((final element) => element.extract());
      soup.findAll('script').forEach((final element) => element.extract());
      final resultElements = soup.findAll('div', class_: 'g');
      int newResults = 0;

      for (final resultElement in resultElements) {
        final linkElement = resultElement.find('a', attrs: {'href': true});
        final link = linkElement?['href'];

        if (link != null && link.isNotEmpty) {
          final uri = Uri.tryParse(link);
          if (uri != null && uri.scheme == 'https') {
            if (link.startsWith("https://www.google") ||
                link.startsWith("https://accounts")) {
              continue;
            }
            if (results.contains(link)) {
              continue;
            }
            results.add(link);
            fetchedResults++;
            newResults++;
          }
        }

        if (fetchedResults >= numResults) {
          break;
        }
      }

      if (newResults == 0) {
        break;
      }

      start += numResults;
      await Future.delayed(sleepInterval ?? Duration.zero);
    }

    client.close();
    return results;
  }
}
