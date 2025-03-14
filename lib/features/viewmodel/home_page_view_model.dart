import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int _selectedNumber = 0;

  int get selectedIndex => _selectedIndex;
  int get selectedNumber => _selectedNumber;

  void selectNumber(int number) {
    _selectedNumber = number;
    _selectedIndex = 1;
    notifyListeners();
  }

  void goBack() {
    _selectedIndex = 0;
    notifyListeners();
  }
}
