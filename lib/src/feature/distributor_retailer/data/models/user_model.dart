class UserModel {
  final String id;
  final String name;
  final String type; // "Distributor" or "Retailer"

  UserModel({required this.id, required this.name, required this.type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'].toString(), name: json['name'], type: json['type']);
  }
}
