import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_service.dart';

enum LoginState { idle, loading, success, error }

class UserViewModel extends ChangeNotifier {
  final AuthService _authService;

  UserViewModel({AuthService? authService})
      : _authService = authService ?? AuthService();

  String _message = '';
  String get message => _message;

  UserModel? _user;
  UserModel? get user => _user;

  LoginState _state = LoginState.idle;
  LoginState get state => _state;

  Future<void> login(String phone, String password) async {
    _state = LoginState.loading;
    _message = '';
    _user = null;
    notifyListeners();

    try {
      final data = await _authService.login(phone, password);

      _message = data['message']?.toString() ?? 'Lỗi không xác định từ server';

      if (data.containsKey('user') && data['user'] != null) {
        _user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        _state = LoginState.success;
      } else {
        _state = LoginState.error;
      }
    } catch (e) {
      _message = 'Lỗi: ${e.toString()}';
      _state = LoginState.error;
    }

    notifyListeners();
  }

  void logout() {
    _message = '';
    _user = null;
    _state = LoginState.idle;
    notifyListeners();
  }
}
