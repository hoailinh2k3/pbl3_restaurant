import 'dart:convert'; // Để decode JSON
import 'package:http/http.dart' as http; // Thư viện http
import 'package:pbl3_restaurant/core/constants/api.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';

class FoodService {
  Future<List<FoodModel>> fetchAllFoods(String token) async {
    try {
      final url = Uri.parse(Api.foodList);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> dataList = jsonData["data"];

        return dataList.map((item) => FoodModel.fromJson(item)).toList();
      } else {
        throw Exception(
            "Failed to load foods. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching foods: $e");
      rethrow;
    }
  }

  Future<void> addFood(FoodModel food, String token) async {
    try {
      final url = Uri.parse(Api.foodAdd).replace(queryParameters: {
        'TenMonAn': food.name,
        'MaDanhMuc': food.categoryId.toString(),
        'Gia': food.price.toString(),
        'urlAnh': food.picture,
      });

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add food');
      }
    } catch (e) {
      print("Error adding food: $e");
      rethrow;
    }
  }

  Future<void> updateFood(FoodModel food, String token) async {
    try {
      final url = Uri.parse(Api.foodUpdate).replace(queryParameters: {
        'ID': food.foodId.toString(),
        'TenMonAn': food.name,
        'MaDanhMuc': food.categoryId.toString(),
        'Gia': food.price.toString(),
        'urlAnh': food.picture,
      });

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update food');
      }
    } catch (e) {
      print("Error updating food: $e");
      rethrow;
    }
  }

  Future<void> deleteFood(int foodId, String token) async {
    try {
      final url = Uri.parse(Api.foodDelete).replace(queryParameters: {
        'ID': foodId.toString(),
      });

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: '',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete food');
      }
    } catch (e) {
      print("Error deleting food: $e");
      rethrow;
    }
  }
}
