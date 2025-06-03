import 'dart:convert';
import 'package:distributor_retailer_app/src/feature/distributor_retailer/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://128.199.98.121/admin/Api';
  static const String token = '4ccda7514adc0f13595a585205fb9761';

  static Future<List<UserModel>> fetchUsers(String type) async {
    final url = Uri.parse('$baseUrl/get_retailer_distributor_master/1');
    final response = await http.get(url, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> addOrUpdateUser(Map<String, String> userData) async {
    final url = Uri.parse('$baseUrl/add_distributor');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = token
      ..fields.addAll(userData);

    final response = await request.send();
    return response.statusCode == 200;
  }
}
