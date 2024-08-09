class ApiKeyModel {
  final String name;
  final String key;
  final String serviceType;
  final bool isDefault;

  ApiKeyModel({
    required this.name,
    required this.key,
    required this.serviceType,
    this.isDefault = false,
  });

  // Convert ApiKeyModel to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'key': key,
      'serviceType': serviceType,
      'isDefault': isDefault,
    };
  }

  // Create ApiKeyModel from a Map
  factory ApiKeyModel.fromMap(Map<String, dynamic> map) {
    return ApiKeyModel(
      name: map['name'] ?? '',
      key: map['key'] ?? '',
      serviceType: map['serviceType'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }


}
