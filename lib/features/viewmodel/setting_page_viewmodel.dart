import 'package:flutter/material.dart';

import '../view/setting/account_setting.dart';
import '../view/setting/branch_setting.dart';
import '../view/setting/food_setting.dart';
import '../view/setting/table_setting.dart';
import '../view/setting/user_setting.dart';

class SettingPageViewmodel extends ChangeNotifier {
  final List<String> _settings = [
    'Quản lý tài khoản',
    'Quản lý thực đơn',
    "Quản lý bàn ăn",
    "Quản lý nhân viên",
    "Quản lý chi nhánh",
  ];

  final List<Widget> _settingPage = [
    AccountSetting(),
    FoodSetting(),
    TableSetting(),
    UserSetting(),
    BranchSetting(),
  ];

  List<Widget> get settingPage => _settingPage;

  List<String> get settings => _settings;
  int _isSelected = 0;

  int get isSelected => _isSelected;

  set isSelected(int index) {
    _isSelected = index;
    notifyListeners();
  }
}
