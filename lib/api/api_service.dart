import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/distributor.dart';

class ApiService {
  final String baseUrl = 'http://128.199.98.121/admin/Api';
  final Map<String, String> headers = {
    'Authorization': '4ccda7514adc0f13595a585205fb9761',
    'Content-Type': 'application/json',
    'Cookie': 'ci_session=lvtdi30a4rvo6rn923nl59h1qn9ro2af', // Use session accordingly
  };

  Future<List<Distributor>> fetchDistributors({int page = 1, int limit = 10, String? type, String? search}) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (type != null) 'type': type,
      if (search != null) 'search': search,
    };

    var url = Uri.parse('$baseUrl/get_retailer_distributor_master/1').replace(queryParameters: queryParams);
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Assuming the API returns a list under 'data' key
      List list = data['data'] ?? [];
      return list.map((json) => Distributor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load distributors');
    }
  }

  Future<bool> addDistributor(Map<String, String> distributorData) async {
    print("Adding distributor with: $distributorData");
    var url = Uri.parse('$baseUrl/add_distributor');
    var request = http.MultipartRequest('POST', url);

    // Extract image path from distributorData and remove it from fields
    String? imagePath = distributorData.remove("image");

    // Add form fields
    request.fields.addAll(distributorData);
    print("Request fields: ${request.fields}");

    // Attach the image file, if present
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      print("Image file attached: $imagePath");
    }

    // Headers
    request.headers.addAll({'Authorization': headers['Authorization']!, 'Cookie': 'ci_session=l61gjlkof6re6h2508c5to8kifl3mjkl'});
    print("Request headers: ${request.headers}");

    // Send the request
    var response = await request.send();
    print("Response: $response");

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print("Response body: $respStr");
      return true;
    } else {
      final errorBody = await response.stream.bytesToString();
      print("Failed to add distributor. Status: ${response.statusCode}, Body: $errorBody");
      return false;
    }
  }

  Future<bool> updateDistributor(Map<String, String> distributorData) async {
    print("Updating distributor with: $distributorData");

    var url = Uri.parse('$baseUrl/add_distributor'); // Still same endpoint
    var request = http.MultipartRequest('POST', url);

    // Extract and remove the image path if present
    String? imagePath = distributorData.remove("image");

    // Add other fields
    request.fields.addAll(distributorData);
    print("Request fields: ${request.fields}");

    // Add image file only if it's provided
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      print("Image file attached: $imagePath");
    } else {
      print("No image selected, skipping image upload.");
    }

    // Add headers
    request.headers.addAll({'Authorization': headers['Authorization']!, 'Cookie': headers['Cookie']!});

    // Send the request
    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print("Status: ${response.statusCode}");
      print("Response body: $respStr");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update distributor.");
        return false;
      }
    } catch (e) {
      print("Exception during update: $e");
      return false;
    }
  }
}
