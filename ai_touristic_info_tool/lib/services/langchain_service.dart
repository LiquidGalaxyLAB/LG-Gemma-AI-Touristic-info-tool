import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

class LangchainService {
  Future<Map<String, dynamic>> generateAnswer(String userQuery) async {
    // Getting API key from env
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set in .env file');
    }

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

  Stream<dynamic> generateStreamAnswer(String userQuery) async* {
    // Getting API key from env
    final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not set in .env file');
    }

    ChatGoogleGenerativeAI llm = ChatGoogleGenerativeAI(
      apiKey: apiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(
        // model: "gemini-1.5-pro",
        model: "gemini-1.0-pro",
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

    yield {'type': 'message', 'data': 'Starting...'};
    final stream = chain
        .stream(PromptValue.string(prompt))
        .map((result) => result.toString());
    print('start stream');
    yield {'type': 'message', 'data': 'Streaming'};
    // print(await stream.isEmpty);
    await for (var result in stream) {
      print(await result);
      yield {
        'type': 'stream',
        'data': result,
      };
    }
    print('done with stream');

    final full_result = chain.invoke(PromptValue.string(prompt));
    yield {'type': 'message', 'data': 'Preparing visualizations'};
    bool isDone = false;
    await full_result.then((value) {
      isDone = true;
    });

    yield {
      'type': 'result',
      'data': full_result,
    };
    if (isDone) {
      yield {
        'type': 'message',
        'data': 'Almost Done! Please wait few seconds...'
      };
    }

    print('full result');
  }
}
