import 'package:pbl3_restaurant/core/constants/api.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> addTable(TableModel table) async {
    final url = Uri.parse(Api.tableAdd).replace(queryParameters: {
      'tableNumber': table.tableNumber.toString(),
      'capacity': table.capacity.toString(),
      'statusID': '1',
      'branchID': table.branchId.toString(),
    });

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: '',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add table');
    }
  }

  Future<void> updateTable(TableModel table) async {
    final url = Uri.parse(Api.tableUpdate).replace(queryParameters: {
      'ID': table.tableId.toString(),
      'tableNumber': table.tableNumber.toString(),
      'capacity': table.capacity.toString(),
      'statusID': '1',
      'branchID': table.branchId.toString(),
    });

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: '',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update table');
    }
  }

  Future<void> deleteTable(int id) async {
    final url = Uri.parse(Api.tableDelete).replace(queryParameters: {
      'ID': id.toString(),
    });

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: '',
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete table');
    }
  }
}
