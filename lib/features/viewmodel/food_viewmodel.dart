import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';
import 'package:pbl3_restaurant/data/repositories/food_service.dart';

class FoodViewModel extends ChangeNotifier {
  FoodViewModel() {
    fetchAllFoods();
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      fetchAllFoods();
    });
  }
  final FoodService _service = FoodService();

  // Danh sách categories
  List<FoodModel> foods = [];

  // Trạng thái tải dữ liệu
  bool isLoading = false;
  String? errorMessage;
  Timer? _timer;

  // Hàm gọi API để lấy danh sách Food
  Future<void> fetchAllFoods() async {
    try {
      isLoading = (foods.isEmpty) ? true : false;
      errorMessage = null;
      notifyListeners();

      foods = await _service.fetchAllFoods();
    } catch (e) {
      // Bắt lỗi, có thể gán errorMessage để hiển thị
      errorMessage = "Không thể tải món ăn: $e";
    } finally {
      isLoading = false; // Kết thúc trạng thái loading
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
