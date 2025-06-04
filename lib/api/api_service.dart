import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/distributor.dart';
import '../constants/api_constants.dart';

class ApiService {
  Future<List<Distributor>> fetchDistributors({int page = 1, int limit = 10, String? type, String? search}) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (type != null) 'type': type,
      if (search != null) 'search': search,
    };

    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDistributorsEndpoint}').replace(queryParameters: queryParams);

    try {
      var response = await http.get(url, headers: ApiConstants.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = data['data'] ?? [];
        return list.map((json) => Distributor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load distributors. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load distributors: $e');
    }
  }

  Future<bool> addDistributor(Map<String, String> distributorData) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addDistributorEndpoint}');
    var request = http.MultipartRequest('POST', url);

    String? imagePath = distributorData.remove("image");
    request.fields.addAll(distributorData);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    request.headers.addAll({'Authorization': ApiConstants.headers['Authorization']!, 'Cookie': ApiConstants.headers['Cookie']!});

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add distributor. Status: ${response.statusCode}, Response: $respStr');
      }
    } catch (e) {
      throw Exception('Failed to add distributor: $e');
    }
  }

  Future<bool> updateDistributor(Map<String, String> distributorData) async {
    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addDistributorEndpoint}');
    var request = http.MultipartRequest('POST', url);

    String? imagePath = distributorData.remove("image");
    request.fields.addAll(distributorData);

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    request.headers.addAll({'Authorization': ApiConstants.headers['Authorization']!, 'Cookie': ApiConstants.headers['Cookie']!});

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update distributor. Status: ${response.statusCode}, Response: $respStr');
      }
    } catch (e) {
      throw Exception('Failed to update distributor: $e');
    }
  }
}
