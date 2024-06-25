class UserQueryModel {
  String country;
  String city;
  String? address;
  String query;

  UserQueryModel({
    required this.country,
    required this.city,
    required this.query,
    this.address,
  });
}
