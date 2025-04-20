import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';

class MenuPageViewModel extends ChangeNotifier {
  final List<String> sortOptions = [
    'Sắp xếp A-Z',
    'Sắp xếp Z-A',
    'Giá tăng dần',
    'Giá giảm dần'
  ];

  // -------------------------
  // Biến quản lý sắp xếp
  String? _selectedSort;
  String? get selectedSort => _selectedSort;

  set selectedSort(String? value) {
    _selectedSort = value;
    notifyListeners(); // Mỗi lần thay đổi sort, View sẽ rebuild
  }

  // -------------------------
  // Biến quản lý danh mục
  int _selectedCategory = 0;
  int get selectedCategory => _selectedCategory;

  set selectedCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  // -------------------------
  // Biến quản lý tìm kiếm
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  void setSearchQuery(String newQuery) {
    _searchQuery = newQuery;
    notifyListeners(); // Mỗi lần thay đổi query, View sẽ rebuild
  }

  // -------------------------
  // Biến quản lý Payment
  bool _isPaid = false;
  bool _isMoney = true;

  bool get isMoney => _isMoney;
  bool get isPaid => _isPaid;

  void updateIsPaid() {
    _isPaid = !_isPaid;
    notifyListeners();
  }

  void setPaid(bool value) {
    if (_isPaid != value) {
      _isPaid = value;
      notifyListeners();
    }
  }

  bool setMoney(bool money) {
    _isMoney = money;
    notifyListeners();
    return _isMoney;
  }

  // -------------------------
  // Hàm lọc - sắp xếp - tìm kiếm
  List<FoodModel> getFilteredFoods(List<FoodModel> allFoods) {
    // 1. Lọc theo danh mục (nếu == 0 thì hiển thị tất cả)
    List<FoodModel> filteredFoods;
    if (_selectedCategory == 0) {
      filteredFoods = allFoods;
    } else {
      filteredFoods = allFoods
          .where((food) => food.categoryId == _selectedCategory)
          .toList();
    }

    // 2. Sắp xếp theo selectedSort
    switch (_selectedSort) {
      case 'Sắp xếp A-Z':
        filteredFoods.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Sắp xếp Z-A':
        filteredFoods.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Giá tăng dần':
        filteredFoods.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Giá giảm dần':
        filteredFoods.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        // Nếu chưa chọn gì hoặc null, giữ nguyên
        break;
    }

    // 3. Tìm kiếm theo searchQuery
    if (_searchQuery.isNotEmpty) {
      filteredFoods = filteredFoods.where((food) {
        return food.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filteredFoods;
  }
}
