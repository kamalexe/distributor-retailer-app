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

  Future<List<Distributor>> fetchDistributors() async {
    var url = Uri.parse('$baseUrl/get_retailer_distributor_master/1');
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
    var url = Uri.parse('$baseUrl/add_distributor');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(distributorData);

    request.headers.addAll({'Authorization': headers['Authorization']!, 'Cookie': 'ci_session=l61gjlkof6re6h2508c5to8kifl3mjkl'});

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      // You can parse respStr for success message if needed
      return true;
    } else {
      return false;
    }
  }
}
