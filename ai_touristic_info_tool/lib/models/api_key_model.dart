/// Class that defines the `API key` entity, which contains its properties and
/// methods.
class ApiKeyModel {

  /// Property that defines the API key `name`.
  final String name;

  /// Property that defines the API key `key`.
  final String key;

  /// Property that defines the API key `serviceType`.  
  final String serviceType;

  /// Property that defines if the API key is the default one.
  final bool isDefault;

  ApiKeyModel({
    required this.name,
    required this.key,
    required this.serviceType,
    this.isDefault = false,
  });

  /// Returns a [Map] from the current [ApiKeyModel].
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'key': key,
      'serviceType': serviceType,
      'isDefault': isDefault,
    };
  }

  /// Returns a [ApiKeyModel] from the given [map].
  factory ApiKeyModel.fromMap(Map<String, dynamic> map) {
    return ApiKeyModel(
      name: map['name'] ?? '',
      key: map['key'] ?? '',
      serviceType: map['serviceType'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }


}
