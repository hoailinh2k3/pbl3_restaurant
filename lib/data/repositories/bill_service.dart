import 'package:pbl3_restaurant/core/constants/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl3_restaurant/data/models/bill_model.dart';

class BillService {
  Future<BillModel> getBill(int tableId, int branchId) async {
    final uri = Uri.parse(Api.billList).replace(queryParameters: {
      'tableId': tableId,
      'branchId': branchId,
    });

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return BillModel.fromJson(jsonMap);
    } else {
      throw Exception(
          'Failed to load bill. Status code: ${response.statusCode}');
    }
  }
}
