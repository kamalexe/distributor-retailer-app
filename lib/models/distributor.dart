class Distributor {
  final String businessName;
  final String name;
  final String mobile;
  final String city;
  final String address;
  final bool isDeleted;
  final String type;
  Distributor({
    required this.businessName,
    required this.name,
    required this.mobile,
    required this.city,
    required this.address,
    required this.isDeleted,
    required this.type,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      businessName: json['business_name'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      isDeleted: json['is_deleted'] == 1 ? true : false,
      type: json['type'] ?? '',
    );
  }
}

