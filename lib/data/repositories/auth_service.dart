// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse(Api.login).replace(queryParameters: {
      'username': username,
      'password': password,
    });

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
      },
      body: '',
    );

    final data = (json.decode(response.body) as Map<String, dynamic>?) ?? {};
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token'] as String);
    }

    data['message'] =
        data['message']?.toString() ?? 'Không có phản hồi từ server';

    return data;
  }

  Future<void> changePassword(String oldP, String newP, String token) async {
    final uri = Uri.parse(Api.changePassword).replace(queryParameters: {
      'oldPassword': oldP,
      'newPassword': newP,
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: '',
    );

    if (response.statusCode != 200) {
      final data = (json.decode(response.body) as Map<String, dynamic>?) ?? {};
      Exception(data['message'].toString());
    }
  }
}
