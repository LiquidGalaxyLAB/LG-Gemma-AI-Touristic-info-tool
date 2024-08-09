import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';

class APIKeySharedPref {
  static SharedPreferences? _prefs;
  static const String _apiKeys = 'api_keys';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save API Keys
  static Future<void> saveApiKeys(List<ApiKeyModel> apiKeys) async {
    List<Map<String, dynamic>> apiKeysMapList =
        apiKeys.map((apiKey) => apiKey.toMap()).toList();
    String apiKeysJson = jsonEncode(apiKeysMapList);
    await _prefs!.setString(_apiKeys, apiKeysJson);
  }

  // Retrieve API Keys
  static Future<List<ApiKeyModel>> getApiKeys() async {
    String? apiKeysJson = _prefs!.getString(_apiKeys);

    if (apiKeysJson != null) {
      List<dynamic> apiKeysMapList = jsonDecode(apiKeysJson);
      return apiKeysMapList
          .map((map) => ApiKeyModel.fromMap(map as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  // Clear API Keys
  static Future<void> clearApiKeys() async {
    await _prefs!.remove(_apiKeys);
  }

  // Add a single API Key
  static Future<void> addApiKey(ApiKeyModel newApiKey) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();

    // Check if the API key already exists
    if (apiKeys.any((apiKey) =>
        apiKey.name == newApiKey.name &&
        apiKey.serviceType == newApiKey.serviceType)) {
      // Update existing key
      apiKeys = apiKeys
          .map((apiKey) => apiKey.name == newApiKey.name &&
                  apiKey.serviceType == newApiKey.serviceType
              ? newApiKey
              : apiKey)
          .toList();
    } else {
      // Add new key
      apiKeys.add(newApiKey);
    }
    await saveApiKeys(apiKeys);
  }

  // Remove a single API Key
  static Future<void> removeApiKey(String name, String serviceType) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();
    apiKeys.removeWhere(
        (apiKey) => apiKey.name == name && apiKey.serviceType == serviceType);
    await saveApiKeys(apiKeys);
  }

  // Edit a single API Key
  static Future<void> editApiKey(
      String name, String newKey, String serviceType) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();
    apiKeys = apiKeys
        .map((apiKey) =>
            apiKey.name == name && apiKey.serviceType == serviceType
                ? ApiKeyModel(
                    name: apiKey.name,
                    key: newKey,
                    serviceType: serviceType,
                    isDefault: apiKey.isDefault)
                : apiKey)
        .toList();
    await saveApiKeys(apiKeys);
  }

  // Save the default API key for a specific service type
  // static Future<void> saveDefaultApiKey(
  //     String serviceType, String keyName) async {
  //   await _prefs!.setString('default_api_key_$serviceType', keyName);

  //   // Update the default key in the stored list
  //   List<ApiKeyModel> apiKeys = await getApiKeys();
  //   apiKeys = apiKeys
  //       .map((apiKey) => apiKey.serviceType == serviceType
  //           ? ApiKeyModel(
  //               name: apiKey.name,
  //               key: apiKey.key,
  //               serviceType: serviceType,
  //               isDefault: apiKey.name == keyName)
  //           : ApiKeyModel(
  //               name: apiKey.name,
  //               key: apiKey.key,
  //               serviceType: serviceType,
  //               isDefault: false))
  //       .toList();
  //   await saveApiKeys(apiKeys);
  // }
  static Future<void> saveDefaultApiKey(
      String serviceType, String keyName) async {
    // Save the new default key for the given service type
    await _prefs!.setString('default_api_key_$serviceType', keyName);

    // Retrieve and update the API keys
    List<ApiKeyModel> apiKeys = await getApiKeys();

    // Update the default key status
    apiKeys = apiKeys.map((apiKey) {
      if (apiKey.serviceType == serviceType) {
        return ApiKeyModel(
          name: apiKey.name,
          key: apiKey.key,
          serviceType: serviceType,
          isDefault: apiKey.name == keyName,
        );
      } else {
        return apiKey;
      }
    }).toList();

    // Save the updated API keys list
    await saveApiKeys(apiKeys);
  }

  // Retrieve the default API key for a specific service type
  static Future<ApiKeyModel?> getDefaultApiKey(String serviceType) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();
    print(apiKeys);
    try {
      return apiKeys
          .firstWhere((key) => key.serviceType == serviceType && key.isDefault);
    } catch (e) {
      return null;
    }
  }
}
