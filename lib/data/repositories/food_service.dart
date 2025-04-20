import 'dart:convert'; // Để decode JSON
import 'package:http/http.dart' as http; // Thư viện http
import 'package:pbl3_restaurant/core/constants/api.dart';
import 'package:pbl3_restaurant/data/models/food_model.dart';

class FoodService {
  Future<List<FoodModel>> fetchAllFoods() async {
    try {
      final url = Uri.parse(Api.foodList);
      final response = await http.get(url);

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
}
