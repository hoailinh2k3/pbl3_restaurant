import 'package:flutter/material.dart';
import '../view/setting/account_setting.dart';
import '../view/setting/food_setting.dart';
import '../view/setting/table_setting.dart';
import '../view/setting/user_setting.dart';
import '../view/setting/branch_setting.dart';
import '../../data/models/user_model.dart';

class SettingPageViewmodel extends ChangeNotifier {
  UserModel? _user;

  // Danh sách gốc (title + widget)
  final List<Map<String, Widget>> _allItems = [
    {'Quản lý tài khoản': AccountSetting()},
    {'Quản lý thực đơn': FoodSetting()},
    {'Quản lý bàn ăn': TableSetting()},
    {'Quản lý nhân viên': UserSetting()},
    {'Quản lý chi nhánh': BranchSetting()},
  ];

  // Danh sách sau khi lọc
  final List<String> _settings = [];
  final List<Widget> _settingPage = [];

  int _isSelected = 0;

  // Constructor khởi tạo filter lần đầu (user có thể null)
  SettingPageViewmodel() {
    _filterByRole();
  }

  /// Gọi từ ProxyProvider khi user thay đổi
  void updateUser(UserModel? user) {
    _user = user;
    _filterByRole();
  }

  void _filterByRole() {
    _settings.clear();
    _settingPage.clear();

    final role = _user?.role;

    if (role == 'Quản lý tổng') {
      for (var m in _allItems) {
        _settings.add(m.keys.first);
        _settingPage.add(m.values.first);
      }
    } else if (role == 'Quản lý chi nhánh') {
      // manager thì không có thực đơn và chi nhánh
      const allowed = [
        'Quản lý tài khoản',
        'Quản lý bàn ăn',
        'Quản lý nhân viên'
      ];
      for (var m in _allItems) {
        final title = m.keys.first;
        if (allowed.contains(title)) {
          _settings.add(title);
          _settingPage.add(m.values.first);
        }
      }
    } else {
      final item =
          _allItems.firstWhere((m) => m.keys.first == 'Quản lý tài khoản');
      _settings.add(item.keys.first);
      _settingPage.add(item.values.first);
    }

    // reset selection về 0 mỗi lần filter
    _isSelected = 0;
    notifyListeners();
  }

  // GETTERS
  List<String> get settings => _settings;
  List<Widget> get settingPage => _settingPage;
  int get isSelected => _isSelected;

  // SETTER để UI bind
  set isSelected(int index) {
    if (index < 0 || index >= _settingPage.length) return;
    _isSelected = index;
    notifyListeners();
  }
}
