import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/category_model.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';
import 'package:pbl3_restaurant/data/repositories/category_respository.dart';
import 'package:pbl3_restaurant/data/repositories/food_respository.dart';

class MenuPageViewModel extends ChangeNotifier {
  MenuPageViewModel() {
    getCategory();
    getFood();
  }

  final List<String> sortOptions = [
    'Sắp xếp A-Z',
    'Sắp xếp Z-A',
    'Giá tăng dần',
    'Giá giảm dần'
  ];

  String? selectedSort;

  List<CategoryModel> _categories = [];
  int _selectedCategory = 0;
  List<CategoryModel> get categories => _categories;
  int get selectedCategory => _selectedCategory;
  set selectedCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  List<FoodModel> _foods = [];
  List<FoodModel> get foods => _foods;

  bool _isPaid = false;
  bool _isMoney = true;

  bool get isMoney => _isMoney;
  bool get isPaid => _isPaid;

  getCategory() async {
    var response = await CategoryRespository().readCategory();
    if (_categories != response) {
      _categories = response;
      notifyListeners();
    }
  }

  getFood() async {
    var response = await FoodRespository().readFood();
    if (_foods != response) {
      _foods = response;
      notifyListeners();
    }
  }

  void updateIsPaid() {
    _isPaid = !_isPaid;
    notifyListeners();
  }

  bool setMoney(bool money) {
    _isMoney = money;
    notifyListeners();
    return _isMoney;
  }
}
