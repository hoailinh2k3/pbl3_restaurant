import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/helpers/get_token.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';
import 'package:pbl3_restaurant/data/repositories/food_service.dart';

class FoodViewModel extends ChangeNotifier {
  FoodViewModel() {
    fetchAllFoods();
  }
  final FoodService _service = FoodService();

  // Danh sách categories
  List<FoodModel> foods = [];

  // Trạng thái tải dữ liệu
  bool isLoading = false;
  String? errorMessage;

  // Hàm gọi API để lấy danh sách Food
  Future<void> fetchAllFoods() async {
    try {
      String token = await getToken();
      isLoading = (foods.isEmpty) ? true : false;
      errorMessage = null;
      notifyListeners();

      foods = await _service.fetchAllFoods(token);
    } catch (e) {
      // Bắt lỗi, có thể gán errorMessage để hiển thị
      errorMessage = "Không thể tải món ăn: $e";
    } finally {
      isLoading = false; // Kết thúc trạng thái loading
      notifyListeners();
    }
  }

  Future<void> addFood(FoodModel food) async {
    foods.add(food);
    notifyListeners();
    try {
      String token = await getToken();
      await _service.addFood(food, token);
      foods.add(food);
    } catch (e) {
      errorMessage = "Không thể thêm món ăn: $e";
    } finally {
      await fetchAllFoods();
      notifyListeners();
    }
  }

  Future<void> updateFood(FoodModel food) async {
    int index = foods.indexWhere((f) => f.foodId == food.foodId);
    if (index != -1) {
      foods[index] = food;
      notifyListeners();
    }
    try {
      String token = await getToken();
      await _service.updateFood(food, token);
      if (index != -1) {
        foods[index] = food;
      }
    } catch (e) {
      errorMessage = "Không thể cập nhật món ăn: $e";
    } finally {
      await fetchAllFoods();
      notifyListeners();
    }
  }

  Future<void> deleteFood(int foodId) async {
    int index = foods.indexWhere((f) => f.foodId == foodId);
    if (index != -1) {
      foods.removeAt(index);
      notifyListeners();
    }
    try {
      String token = await getToken();
      await _service.deleteFood(foodId, token);
    } catch (e) {
      errorMessage = "Không thể xóa món ăn: $e";
    } finally {
      await fetchAllFoods();
      notifyListeners();
    }
  }
}
