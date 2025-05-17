import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl3_restaurant/core/constants/api.dart';
import '../models/category_model.dart';

class CategoryService {
  Future<List<CategoryModel>> fetchCategories(String token) async {
    try {
      final url = Uri.parse(Api.categoryList);
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

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

  Future<void> addCategory(CategoryModel category, String token) async {
    try {
      final url = Uri.parse(Api.categoryAdd).replace(queryParameters: {
        'TenDanhMuc': category.categoryName,
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
        throw Exception('Failed to add category');
      }
    } catch (e) {
      print("Error adding category: $e");
      rethrow;
    }
  }

  Future<void> updateCategory(CategoryModel category, String token) async {
    try {
      final url = Uri.parse(Api.categoryUpdate).replace(queryParameters: {
        'ID': category.categoryId.toString(),
        'TenDanhMuc': category.categoryName,
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
        print(response.body);
        throw Exception('Failed to update category');
      }
    } catch (e) {
      print("Error updating category: $e");
      rethrow;
    }
  }

  Future<void> deleteCategory(int categoryId, String token) async {
    try {
      final url = Uri.parse(Api.categoryDelete).replace(queryParameters: {
        'ID': categoryId.toString(),
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
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      print("Error deleting category: $e");
      rethrow;
    }
  }
}
