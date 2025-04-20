import 'package:flutter/foundation.dart';

class SettingPageViewmodel extends ChangeNotifier {
  final List<String> _settings = [
    'Quản lý tài khoản',
    'Quản lý thực đơn',
    "Quản lý bàn ăn",
    "Quản lý nhân viên",
    "Quản lý chi nhánh",
  ];

  List<String> get settings => _settings;
  int _isSelected = 0;

  int get isSelected => _isSelected;

  set isSelected(int index) {
    _isSelected = index;
    notifyListeners();
  }
}
