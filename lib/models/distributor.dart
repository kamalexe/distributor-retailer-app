class Distributor {
  final String id;
  final String type;
  final String businessName;
  final String businessType;
  final String gstNo;
  final String address;
  final String pincode;
  final String name;
  final String mobile;
  final String state;
  final String city;
  final int regionId;
  final int areaId;
  final int appPk;
  final String image;
  final int bankAccountId;
  final bool isApproved;
  final String openTime;
  final String closeTime;
  final int parentId;
  final bool isAsync;
  final List<String> brands;
  final bool isDelete;

  Distributor({
    required this.id,
    required this.type,
    required this.businessName,
    required this.businessType,
    required this.gstNo,
    required this.address,
    required this.pincode,
    required this.name,
    required this.mobile,
    required this.state,
    required this.city,
    required this.regionId,
    required this.areaId,
    required this.appPk,
    required this.image,
    required this.bankAccountId,
    required this.isApproved,
    required this.openTime,
    required this.closeTime,
    required this.parentId,
    required this.isAsync,
    required this.brands,
    required this.isDelete,
  });

  // Factory constructor to create Distributor from JSON
  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'] ?? '',
      gstNo: json['gst_no'] ?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      regionId: int.tryParse(json['region_id']?.toString() ?? '0') ?? 0,
      areaId: int.tryParse(json['area_id']?.toString() ?? '0') ?? 0,
      appPk: int.tryParse(json['app_pk']?.toString() ?? '1') ?? 1,
      image: json['image'] ?? '',
      bankAccountId: int.tryParse(json['bank_account_id']?.toString() ?? '0') ?? 0,
      isApproved: json['isApproved'] == '1' || json['isApproved'] == true,
      openTime: json['open_time'] ?? '00:00',
      closeTime: json['close_time'] ?? '00:00',
      parentId: int.tryParse(json['parent_id']?.toString() ?? '0') ?? 0,
      isAsync: json['is_async'] == '1' || json['is_async'] == true,
      brands: _parseBrands(json['brands']),
      isDelete: json['is_delete'] == '1' || json['is_delete'] == true,
    );
  }

  // Helper method to parse brands (can be comma-separated string or single value)
  static List<String> _parseBrands(dynamic brandsData) {
    if (brandsData == null) return [];

    String brandsString = brandsData.toString();
    if (brandsString.isEmpty || brandsString == '0') return [];

    // If it contains comma, split it
    if (brandsString.contains(',')) {
      return brandsString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty && e != '0').toList();
    }

    // Single brand
    return brandsString.trim().isNotEmpty && brandsString != '0' ? [brandsString.trim()] : [];
  }

  // Convert Distributor to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'business_name': businessName,
      'business_type': businessType,
      'gst_no': gstNo,
      'address': address,
      'pincode': pincode,
      'name': name,
      'mobile': mobile,
      'state': state,
      'city': city,
      'region_id': regionId.toString(),
      'area_id': areaId.toString(),
      'app_pk': appPk.toString(),
      'image': image,
      'bank_account_id': bankAccountId.toString(),
      'isApproved': isApproved ? '1' : '0',
      'open_time': openTime,
      'close_time': closeTime,
      'parent_id': parentId.toString(),
      'is_async': isAsync ? '1' : '0',
      'brands': brands.join(','),
      'is_delete': isDelete ? '1' : '0',
    };
  }

  // Copy with method for creating modified copies
  Distributor copyWith({
    String? id,
    String? type,
    String? businessName,
    String? businessType,
    String? gstNo,
    String? address,
    String? pincode,
    String? name,
    String? mobile,
    String? state,
    String? city,
    int? regionId,
    int? areaId,
    int? appPk,
    String? image,
    int? bankAccountId,
    bool? isApproved,
    String? openTime,
    String? closeTime,
    int? parentId,
    bool? isAsync,
    List<String>? brands,
    bool? isDelete,
  }) {
    return Distributor(
      id: id ?? this.id,
      type: type ?? this.type,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      gstNo: gstNo ?? this.gstNo,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      state: state ?? this.state,
      city: city ?? this.city,
      regionId: regionId ?? this.regionId,
      areaId: areaId ?? this.areaId,
      appPk: appPk ?? this.appPk,
      image: image ?? this.image,
      bankAccountId: bankAccountId ?? this.bankAccountId,
      isApproved: isApproved ?? this.isApproved,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      parentId: parentId ?? this.parentId,
      isAsync: isAsync ?? this.isAsync,
      brands: brands ?? this.brands,
      isDelete: isDelete ?? this.isDelete,
    );
  }

  // toString method for debugging
  @override
  String toString() {
    return 'Distributor{id: $id, businessName: $businessName, type: $type, state: $state, city: $city}';
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Distributor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Response wrapper class for API responses
class DistributorResponse {
  final String status;
  final String message;
  final String limit;
  final int numberOfPages;
  final String total;
  final String page;
  final List<Distributor> data;

  DistributorResponse({
    required this.status,
    required this.message,
    required this.limit,
    required this.numberOfPages,
    required this.total,
    required this.page,
    required this.data,
  });

  factory DistributorResponse.fromJson(Map<String, dynamic> json) {
    return DistributorResponse(
      status: json['st'] ?? '',
      message: json['msg'] ?? '',
      limit: json['limit'] ?? '',
      numberOfPages: int.tryParse(json['number_of_page']?.toString() ?? '0') ?? 0,
      total: json['total'] ?? '',
      page: json['page'] ?? '',
      data: (json['data'] as List<dynamic>?)?.map((item) => Distributor.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'st': status,
      'msg': message,
      'limit': limit,
      'number_of_page': numberOfPages.toString(),
      'total': total,
      'page': page,
      'data': data.map((distributor) => distributor.toJson()).toList(),
    };
  }
}
