import 'package:pbl3_restaurant/core/constants/api.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'dart:convert'; // Để decode JSON
import 'package:http/http.dart' as http; // Thư viện http

class TableService {
  Future<List<TableModel>> fetchTables(int id) async {
    final url = Uri.parse("${Api.tableList}?branchId=$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> dataList = jsonData["data"];
      return dataList.map((item) => TableModel.fromJson(item)).toList();
    } else {
      throw Exception(
          "Failed to load tables. Status code: ${response.statusCode}");
    }
  }
}
