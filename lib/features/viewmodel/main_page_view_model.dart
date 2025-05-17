import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/user_model.dart';
import 'package:pbl3_restaurant/features/view/home/home_page.dart';
import 'package:pbl3_restaurant/features/view/setting/setting_page.dart';
import 'package:pbl3_restaurant/features/view/statistic/statistic_page.dart';

class MainPageViewModel extends ChangeNotifier {
  UserModel? _user;

  // Các item gốc (giữ nguyên thứ tự)
  final _allRailItems = [
    {'icon': Icons.home, 'title': 'Trang chủ'},
    {'icon': Icons.bar_chart_rounded, 'title': 'Thống kê'},
    {'icon': Icons.settings, 'title': 'Thiết lập'},
  ];
  final _allPages = [
    () => HomePage(),
    () => StatisticPage(),
    () => SettingPage(),
  ];

  // Chỉ số đang chọn
  int _currentIndex = 0;

  // Danh sách sau lọc
  List<Map<String, dynamic>> _railItems = [];
  List<Widget> _pages = [];

  MainPageViewModel() {
    _filterByRole();
  }

  void updateUser(UserModel? user) {
    _user = user;
    _filterByRole();
  }

  void _filterByRole() {
    _railItems.clear();
    _pages.clear();

    if (_user == null) _currentIndex = 0;

    if (_user?.role != 'Quản lý tổng') {
      _railItems.add(_allRailItems[0]);
      _pages.add(_allPages[0]());
    }

    if (_user?.role != 'Nhân viên') {
      _railItems.add(_allRailItems[1]);
      _pages.add(_allPages[1]());
    }

    _railItems.add(_allRailItems[2]);
    _pages.add(_allPages[2]());

    if (_currentIndex >= _pages.length) {
      _currentIndex = _pages.length - 1;
    }
    if (_currentIndex < 0 && _pages.isNotEmpty) {
      _currentIndex = 0;
    }

    notifyListeners();
  }

  // Getters
  List<Map<String, dynamic>> get railItems => _railItems;
  List<Widget> get pages => _pages;
  int get currentIndex => _currentIndex;
  int get previousIndex => _currentIndex - 1;
  int get postIndex => _currentIndex + 1;

  // Cập nhật khi user click
  void updateIndex(int index) {
    if (index < 0 || index >= _pages.length) return;
    _currentIndex = index;
    notifyListeners();
  }
}
