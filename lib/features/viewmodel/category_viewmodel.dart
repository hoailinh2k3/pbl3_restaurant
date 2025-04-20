import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/category_model.dart';
import 'package:pbl3_restaurant/data/repositories/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  CategoryViewModel() {
    fetchCategories();
  }
  final CategoryService _service = CategoryService();

  List<CategoryModel> categories = [];

  String? errorMessage;

  Future<void> fetchCategories() async {
    try {
      errorMessage = null;
      notifyListeners();

      categories = await _service.fetchCategories();
    } catch (e) {
      errorMessage = "Không thể tải danh mục: $e";
    } finally {
      notifyListeners();
    }
  }
}
