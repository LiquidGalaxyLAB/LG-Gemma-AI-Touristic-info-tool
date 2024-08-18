import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_touristic_info_tool/models/api_key_model.dart';

///`APIKeySharedPref` to presist data in the app locally
/// A utility class for managing and persisting API keys session data locally using `shared_preferences`.
class APIKeySharedPref {
  static SharedPreferences? _prefs;
  static const String _apiKeys = 'api_keys';

  /// Initializes the SharedPreferences instance for local data storage.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save API keys for the API session
  static Future<void> saveApiKeys(List<ApiKeyModel> apiKeys) async {
    List<Map<String, dynamic>> apiKeysMapList =
        apiKeys.map((apiKey) => apiKey.toMap()).toList();
    String apiKeysJson = jsonEncode(apiKeysMapList);
    await _prefs!.setString(_apiKeys, apiKeysJson);
  }

  /// Retrieve API keys for the API session
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

  /// Clear all API keys from the session
  static Future<void> clearApiKeys() async {
    await _prefs!.remove(_apiKeys);
  }

  /// Add a single API key to the session
  static Future<void> addApiKey(ApiKeyModel newApiKey) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();

    if (apiKeys.any((apiKey) =>
        apiKey.name == newApiKey.name &&
        apiKey.serviceType == newApiKey.serviceType)) {
      apiKeys = apiKeys
          .map((apiKey) => apiKey.name == newApiKey.name &&
                  apiKey.serviceType == newApiKey.serviceType
              ? newApiKey
              : apiKey)
          .toList();
    } else {
      apiKeys.add(newApiKey);
    }
    await saveApiKeys(apiKeys);
  }

  /// Remove a single API key from the session
  static Future<void> removeApiKey(String name, String serviceType) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();
    apiKeys.removeWhere(
        (apiKey) => apiKey.name == name && apiKey.serviceType == serviceType);
    await saveApiKeys(apiKeys);
  }

  /// Edit a single API key in the session
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
  
  /// Save the default API key for a specific service type
  static Future<void> saveDefaultApiKey(
      String serviceType, String keyName) async {
    await _prefs!.setString('default_api_key_$serviceType', keyName);

    List<ApiKeyModel> apiKeys = await getApiKeys();

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

    await saveApiKeys(apiKeys);
  }

  /// Retrieve the default API key for a specific service type
  static Future<ApiKeyModel?> getDefaultApiKey(String serviceType) async {
    List<ApiKeyModel> apiKeys = await getApiKeys();
    try {
      return apiKeys
          .firstWhere((key) => key.serviceType == serviceType && key.isDefault);
    } catch (e) {
      return null;
    }
  }
}
