import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl3_restaurant/core/constants/api.dart';
import '../models/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final url = Uri.parse(Api.categoryList);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final List<dynamic> dataList = jsonData["data"];

        final List<CategoryModel> categories =
            dataList.map((item) => CategoryModel.fromJson(item)).toList();

        return categories;
      } else {
        throw Exception(
            "Failed to load categories. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }
}
