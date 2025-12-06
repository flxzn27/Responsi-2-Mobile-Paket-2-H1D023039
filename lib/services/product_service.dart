import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class ProductService {
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // GET ALL
  Future<List<dynamic>> getProducts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(ApiConstants.products),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    }
    return [];
  }

  // ADD
  Future<bool> addProduct(Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(ApiConstants.products),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  // UPDATE
  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('${ApiConstants.products}/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  // DELETE
  Future<bool> deleteProduct(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.products}/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}