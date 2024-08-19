


import 'package:ai_touristic_info_tool/services/search_services.dart';
import 'package:flutter/material.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A service class to interact with the Gemini API, including validating API keys and generating AI-powered responses to user queries. 
class GeminiServices {
 
  /// Validates the provided API key by sending a test query to the Gemini API.
  ///
  /// [apiKey] is the API key to be validated.
  /// [context] is the BuildContext used for localization.
  /// 
  /// Returns an empty string if the API key is valid, otherwise returns
  /// an error message localized for the current context.
  Future<String> checkAPIValidity(String apiKey, BuildContext context) async {
    final testQuery = 'Hello';

    try {
      final llm = ChatGoogleGenerativeAI(
        apiKey: apiKey,
        defaultOptions: ChatGoogleGenerativeAIOptions(
          model: 'gemini-1.0-pro',
        ),
      );

      // ignore: unused_local_variable
      final response = await llm.invoke(PromptValue.string(testQuery));
      return '';
    } catch (e) {
      return AppLocalizations.of(context)!
          .aiGenerationAPIGemini_error1(e.toString());
    }
  }

  /// Generates a stream of AI-powered responses based on the user's query.
  ///
  /// [userQuery] is the question or query input by the user.
  /// [apiKey] is the API key for the Gemini API.
  ///
  /// Yields a series of messages and streaming data as the AI processes the query.
  Stream<dynamic> generateStreamAnswer(String userQuery, String apiKey) async* {
    try {
      List<String> links = await SearchServices().fetchUrls(userQuery);
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
      yield {
        'type': 'message',
        'data': 'Streaming'
      };
      await for (var result in stream) {
        final placeCount = RegExp(r'name').allMatches(result.toString()).length;
        if (result.toString().contains('name:')) {
          if (currPlaceCount < placeCount) {
            currPlaceCount = placeCount;
            yield {
              'type': 'message',
              'data': 'Streaming',
            };
          }
        }
        yield {
          'type': 'stream',
          'data': result,
        };
      }
      yield {
        'type': 'message',
        'data': 'Preparing visualizations'
      };
        } catch (e) {
      print('exception');
      print(e);
      yield {
        'type': 'error',
        'data': 'An error occurred: ${e.toString()}'

      };

    }
  }


}
