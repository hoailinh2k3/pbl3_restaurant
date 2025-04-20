import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/view/home/home_page.dart';
import 'package:pbl3_restaurant/features/view/setting/setting_page.dart';
import 'package:pbl3_restaurant/features/view/statistic/statistic_page.dart';

class MainPageViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _railItems = [
    {'icon': Icons.home, 'title': 'Trang chủ'},
    {'icon': Icons.bar_chart_rounded, 'title': 'Thống kê'},
    {'icon': Icons.settings, 'title': 'Thiết lập'},
  ];
  final List<Widget> _pages = [
    HomePage(),
    StatisticPage(),
    SettingPage(),
  ];

  int get currentIndex => _currentIndex;
  int get previousIndex => _currentIndex - 1;
  int get postIndex => _currentIndex + 1;

  List<Map<String, dynamic>> get railItems => _railItems;
  List<Widget> get pages => _pages;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
