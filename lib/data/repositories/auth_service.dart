// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    data['message'] =
        data['message']?.toString() ?? 'Không có phản hồi từ server';

    return data;
  }
}
