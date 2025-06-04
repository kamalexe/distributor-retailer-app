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

    print('🔍 API Request:');
    print('URL: $url');
    print('Headers: ${ApiConstants.headers}');
    print('Query Parameters: $queryParams');

    try {
      var response = await http.get(url, headers: ApiConstants.headers);

      print('📥 API Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = data['data'] ?? [];
        print('📦 Parsed Data Count: ${list.length}');

        final distributors = list.map((json) => Distributor.fromJson(json)).toList();
        print('✅ Successfully parsed ${distributors.length} distributors');
        return distributors;
      } else {
        print('❌ Error: Failed to load distributors. Status code: ${response.statusCode}');
        throw Exception('Failed to load distributors. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('❌ Exception during API call:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load distributors: $e');
    }
  }

  Future<bool> addDistributor(Map<String, String> distributorData) async {
    print('📤 Adding distributor:');
    print('Data: $distributorData');

    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addDistributorEndpoint}');
    var request = http.MultipartRequest('POST', url);

    String? imagePath = distributorData.remove("image");
    request.fields.addAll(distributorData);

    print('📦 Request fields: ${request.fields}');

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      print('📎 Image file attached: $imagePath');
    }

    request.headers.addAll({'Authorization': ApiConstants.headers['Authorization']!, 'Cookie': ApiConstants.headers['Cookie']!});

    print('🔑 Request headers: ${request.headers}');

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('📥 Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $respStr');

      if (response.statusCode == 200) {
        print('✅ Successfully added distributor');
        return true;
      } else {
        print('❌ Failed to add distributor. Status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ Exception during add distributor:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> updateDistributor(Map<String, String> distributorData) async {
    print('📤 Updating distributor:');
    print('Data: $distributorData');

    var url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addDistributorEndpoint}');
    var request = http.MultipartRequest('POST', url);

    String? imagePath = distributorData.remove("image");
    request.fields.addAll(distributorData);

    print('📦 Request fields: ${request.fields}');

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      print('📎 Image file attached: $imagePath');
    } else {
      print('ℹ️ No image selected, skipping image upload');
    }

    request.headers.addAll({'Authorization': ApiConstants.headers['Authorization']!, 'Cookie': ApiConstants.headers['Cookie']!});

    print('🔑 Request headers: ${request.headers}');

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print('📥 Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $respStr');

      if (response.statusCode == 200) {
        print('✅ Successfully updated distributor');
        return true;
      } else {
        print('❌ Failed to update distributor. Status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ Exception during update distributor:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
