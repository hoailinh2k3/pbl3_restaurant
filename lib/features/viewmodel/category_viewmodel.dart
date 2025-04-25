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

  Future<void> addCategory(CategoryModel category) async {
    categories.add(category);
    notifyListeners();
    try {
      await _service.addCategory(category);
      categories.add(category);
    } catch (e) {
      errorMessage = "Không thể thêm danh mục: $e";
    } finally {
      await fetchCategories();
      notifyListeners();
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    int index =
        categories.indexWhere((c) => c.categoryId == category.categoryId);
    if (index != -1) {
      categories[index] = category;
      notifyListeners();
    }
    try {
      await _service.updateCategory(category);
      if (index != -1) {
        categories[index] = category;
      }
    } catch (e) {
      errorMessage = "Không thể cập nhật danh mục: $e";
    } finally {
      await fetchCategories();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    int index = categories.indexWhere((c) => c.categoryId == categoryId);
    if (index != -1) {
      categories.removeAt(index);
      notifyListeners();
    }
  }
}
