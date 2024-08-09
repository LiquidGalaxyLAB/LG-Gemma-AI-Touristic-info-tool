import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ai_touristic_info_tool/helpers/apiKey_shared_pref.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_community/langchain_community.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class LangchainService {
  Future<Map<String, dynamic>> generateAnswer(
      String userQuery, String apiKey) async {
    // Getting API key from env
    // final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // ApiKeyModel? apiKeyModel =
    //     await APIKeySharedPref.getDefaultApiKey('Gemini');
    // String apiKey;
    // if (apiKeyModel == null) {
    //   throw Exception('Gemini Key is not set.');
    // } else {
    //   apiKey = apiKeyModel.key;
    // }

    // if (apiKey.isEmpty) {
    //   throw Exception('GEMINI_API_KEY is not set.');
    // }

    ChatGoogleGenerativeAI llm = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(
        model: "gemini-1.5-pro",
      ),
    );

    String prompt = '''
        You are an advanced AI model acting as a touristic guide with extensive knowledge of various travel destinations and touristic information. 
        Use your internal knowledge to generate a comprehensive and accurate response.
        Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
        Your answer must include the accurate address of each of the 10 places too.
        Your answer must include the country.
        Your answer must include additional information such as: pricing, rating, and amenities.
        If any of the information is not available to you, leave empty.
        Do not include null in your response. 
        Do not omit any place from the list for brevity. 
        Your answer MUST include all 10 places.
        Make sure to include a "source" key with the URL from which the information for each place was retrieved.
        Your answer must be in a well-defined JSON format, with correct curly braces, commas, and quotes. Only use double quotes for strings in your JSON format.
        Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string), source (string). 
        If a string is empty, do not write null, just leave it as an empty string.
        If a float is empty, write it as 0.0
        The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.
        The response should not be enclosed in a code section.

        QUESTION: $userQuery

        YOUR ANSWER:
    ''';

    final outputParser = JsonOutputParser<ChatResult>();
    final chain = llm.pipe(outputParser);

    // final stream = chain.stream(PromptValue.string(prompt));
    // final stream = chain
    //     .stream(PromptValue.string(prompt))
    //     .map((result) => result.toString());
    final full_result = chain.invoke(PromptValue.string(prompt));

    return full_result;

    // return {'stream': stream, 'full_result': full_result};
  }

  Future<String> checkAPIValidity(String apiKey) async {
    final testQuery = 'Hello';

    try {
      final llm = ChatGoogleGenerativeAI(
        apiKey: apiKey,
        defaultOptions: ChatGoogleGenerativeAIOptions(
          model: 'gemini-1.0-pro',
        ),
      );

      final response = await llm.invoke(PromptValue.string(testQuery));
      return '';
    } catch (e) {
      // Handle exceptions that indicate invalid API key
      print('An Error Occured: ${e.toString()}');
      return 'An Error Occured: ${e.toString()}';
    }
  }

  Stream<dynamic> generateStreamAnswer(String userQuery, String apiKey) async* {
    // Getting API key from env
    // final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // if (apiKey.isEmpty) {
    //   throw Exception('GEMINI_API_KEY is not set in .env file');
    // }
    try {
      // List<String> links = await fetchUrls(userQuery);
      List<String> links = await fetchUrlsTemp(userQuery);
      print(links);

      final embeddings = GoogleGenerativeAIEmbeddings(
        apiKey: apiKey,
      );

      // final loader = WebBaseLoader(links);
      // final documents = await loader.load();
      // const textSplitter = RecursiveCharacterTextSplitter(
      //   chunkSize: 1000,
      //   chunkOverlap: 200,
      // );
      // final splits = textSplitter.splitDocuments(documents);
      final vectorStore = MemoryVectorStore(embeddings: embeddings);
      await vectorStore.addDocuments(
        // documents: splits
        documents: [
          Document(pageContent: 'LangChain was created by Harrison'),
          Document(
              pageContent: 'David ported LangChain to Dart in LangChain.dart'),
        ],
      );

      final retriever = vectorStore.asRetriever();
      final setupAndRetrieval = Runnable.fromMap<String>({
        'context': retriever.pipe(
          Runnable.mapInput(
              (docs) => docs.map((d) => d.pageContent).join('\n')),
        ),
        'question': Runnable.passthrough(),
      });

      ChatGoogleGenerativeAI llm = ChatGoogleGenerativeAI(
        apiKey: apiKey,
        defaultOptions: ChatGoogleGenerativeAIOptions(
          model: "gemini-1.5-pro",
          // model: "gemini-1.0-pro",
        ),
      );

      String prompt = '''
        You are an advanced AI model acting as a touristic guide with extensive knowledge of various travel destinations and touristic information. 
        Use your internal knowledge to generate a comprehensive and accurate response.
        Your answer must include Top 10 places, not more not less, with a brief description of each place, and what makes it unique.
        Your answer must include the accurate address of each of the 10 places too.
        Your answer must include the country.
        Your answer must include additional information such as: pricing, rating, and amenities.
        If any of the information is not available to you, leave empty.
        Do not include null in your response. 
        Do not omit any place from the list for brevity. 
        Your answer MUST include all 10 places.
        Make sure to include a "source" key with the URL from which the information for each place was retrieved.
        Your answer must be in a well-defined valid JSON format, with correct curly braces, commas, and quotes. Only use double quotes for strings in your JSON format.
        Each Place should include the following details: name (string), address (string), city (string), country (string), description (string), pricing (string), rating (float), amenities (string), source (string). 
        If a string is empty, do not write null, just leave it as an empty string.
        If a float is empty, write it as 0.0
        **Any key in the JSON must be wrapped by double quotes.**
        The response should be in UTF-8 JSON format, all places enclosed in the 'places' field of the JSON to be returned without any extra comments or quote wrappers.
        The response should not be enclosed in a code section.


        
        QUESTION: {question}

        YOUR ANSWER:
    ''';

      // QUESTION: $userQuery
      //QUESTION: {question}

      final outputParser = JsonOutputParser<ChatResult>();
      // final chain = llm.pipe(outputParser);

      ///
      Set<String> inputVariables = {};
      inputVariables.add('question');
      final chain = setupAndRetrieval
          .pipe(
              PromptTemplate(inputVariables: inputVariables, template: prompt))
          .pipe(llm)
          .pipe(outputParser);

      yield {'type': 'message', 'data': 'Starting...'};

      int currPlaceCount = 0;

      // final stream = chain.stream(PromptValue.string(prompt));
      // .map((result) => result.toString());
      final stream = chain.stream(userQuery);
      print('start stream');
      yield {'type': 'message', 'data': 'Streaming'};
      // print(await stream.isEmpty);
      await for (var result in stream) {
        final placeCount = RegExp(r'name').allMatches(result.toString()).length;
        if (result.toString().contains('name:')) {
          print('results contains name');
          if (currPlaceCount < placeCount) {
            currPlaceCount = placeCount;
            print('increment');
            print(placeCount);
            print(currPlaceCount);
            yield {
              'type': 'message',
              'data': 'Streaming',
            };
          }
        }
        print(await result);
        yield {
          'type': 'stream',
          'data': result,
        };
      }
      // print('done with stream');

      // final full_result = chain.invoke(PromptValue.string(prompt));
      // final full_result = chain.invoke(userQuery);
      yield {'type': 'message', 'data': 'Preparing visualizations'};
      // bool isDone = false;
      // await full_result.then((value) {
      //   isDone = true;
      // });

      // yield {
      //   'type': 'result',
      //   'data': full_result,
      // };
      // if (isDone) {
      //   yield {
      //     'type': 'message',
      //     'data': 'Almost Done! Please wait few seconds...'
      //   };
      // }

      print('full result');
    } catch (e) {
      print('exception');
      // Handle exceptions and provide user-friendly error messages
      yield {'type': 'error', 'data': 'An error occurred: ${e.toString()}'};
    }
  }

  // Future<Map<String, dynamic>> generatewebLinks(String placeName) async {
  //   // Getting API key from env
  //   final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  //   if (apiKey.isEmpty) {
  //     throw Exception('GEMINI_API_KEY is not set in .env file');
  //   }

  //   ChatGoogleGenerativeAI llm = ChatGoogleGenerativeAI(
  //     apiKey: apiKey,
  //     defaultOptions: ChatGoogleGenerativeAIOptions(
  //       model: "gemini-1.5-pro",
  //     ),
  //   );

  //   String prompt = '''
  //     You are an advanced AI model with access to extensive knowledge about travel destinations and online sources.
  //     Your task is to find exactly 10 relevant URLs related to a specific place name.
  //     Provide only the URLs, without any additional descriptions or comments.
  //     Each URL should be accessible and provide information related to the given place name.
  //     Your answer must be in a well-defined JSON format, with correct curly braces, commas, and quotes. Only use double quotes for strings in your JSON format.
  //     The response should be in UTF-8 JSON format, all links enclosed in the 'links' field of the JSON to be returned without any extra comments or quote wrappers.
  //     The value is the list of URLs
  //     The response should not be enclosed in a code section.

  //     QUESTION: Find 10 URLs related to "$placeName".

  //     YOUR ANSWER:
  // ''';

  //   final outputParser = JsonOutputParser<ChatResult>();
  //   final chain = llm.pipe(outputParser);

  //   final links = chain.invoke(PromptValue.string(prompt));

  //   return links;
  // }

  Future<List<String>> fetchUrls(String userQuery, {int urlNum = 20}) async {
    final searchUrl =
        'https://www.google.com/search?q=${Uri.encodeComponent(userQuery)}';
    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      // Parse the HTML content using BeautifulSoup
      final soup = BeautifulSoup(response.body);

      // Find all links that match Google search result pattern
      final linkTags = soup.findAll('a');
      print(linkTags.length);
      print(linkTags);
// # [<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
// #  <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
// #  <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]
      List<String> links = [];
      for (var tag in linkTags) {
        final href = tag.attributes['href'];
        if (href != null &&
            href.startsWith('/url?q=https') &&
            links.length < urlNum) {
          final link = href.split('/url?q=')[1].split('&')[0];
          links.add(link);
        }
      }

      print(links.length);
      print(links[0]);
      return links;
    } else {
      throw Exception('Failed to load Google search results');
    }
  }

  Future<List<String>> fetchUrlsTemp(
    String term, {
    int numResults = 40,
    String lang = 'en',
    Duration? sleepInterval,
    Duration? timeout,
    String? safe = 'active',
    String? region,
  }) async {
    const _userAgentList = [
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.62',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0'
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
          'q':
              '$term -tripadvisor -inurl:http', // Exclude TripAdvisor and URLs containing "http" in the path
          'num':
              '${numResults + 2}', // Request slightly more results to handle potential duplicates
          'hl': lang,
          'start': '$start',
          'safe': safe,
          'gl': region,
        },
      );

      final response = await client.get(
        // Uri.parse('https://www.google.com/search'),
        uri,
        headers: {
          'User-Agent': _userAgentList[random.nextInt(_userAgentList.length)],
        },
      ).timeout(timeout ?? const Duration(seconds: 5));

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to fetch search results. Status code: ${response.statusCode}');
      }

      final soup = BeautifulSoup(response.body);
      // soup.findAll('style').forEach((final element) => element.extract());
      // soup.findAll('script').forEach((final element) => element.extract());
      final resultElements = soup.findAll('div', class_: 'g');
      int newResults = 0;

      for (final resultElement in resultElements) {
        final linkElement = resultElement.find('a', attrs: {'href': true});
        final link = linkElement?['href'];

        if (link != null && link.isNotEmpty) {
          final uri = Uri.tryParse(link);
          if (uri != null && uri.scheme == 'https') {
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
        // No more results on this page, stop searching
        break;
      }

      start +=
          numResults; // Move to the next page of results (e.g., if numResults = 10, then start=10, 20, 30...)
      await Future.delayed(sleepInterval ?? Duration.zero);
    }

    client.close();
    return results;
  }
}
