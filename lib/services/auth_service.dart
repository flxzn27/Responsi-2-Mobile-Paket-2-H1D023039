import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']); // Simpan token
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      body: {'name': name, 'email': email, 'password': password},
    );
    return response.statusCode == 201;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse(ApiConstants.logout),
        headers: {'Authorization': 'Bearer $token'},
      );
    }
    await prefs.remove('token');
  }
}
