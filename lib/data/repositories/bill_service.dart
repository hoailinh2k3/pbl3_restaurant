import 'package:pbl3_restaurant/core/constants/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl3_restaurant/data/models/bill_model.dart';

// bill_service.dart
class BillService {
  Future<BillModel?> fetchBill(int tableId) async {
    final uri = Uri.parse(Api.billList).replace(queryParameters: {
      'tableId': tableId.toString(),
    });

    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('billId')) {
          return BillModel.fromJson(jsonData);
        } else {
          return null;
        }
      } catch (e, st) {
        print('ERROR → parse JSON in BillService: $e');
        print(st);
        rethrow;
      }
    } else {
      throw Exception(
          'Failed to load bill. Status code: ${response.statusCode}');
    }
  }

  Future<bool> upsertFood(int tableId, List<DanhSachMon> items) async {
    final uri = Uri.parse('${Api.baseUrl}/Bill/\$tableId/UpsertFood');
    final payload = items.map((e) => e.toUpsertJson()).toList();

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to upsert foods. Status code: \${response.statusCode}');
    }
  }

  Future<bool> deleteBillItem(List<int> billItemId) async {
    final uri = Uri.parse(Api.billDeleteFood);

    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: billItemId,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete bill item. Status code: ${response.statusCode}');
    }
  }

  Future<bool> checkout(int billId, int paymentMethodId) async {
    final uri = Uri.parse(Api.billCheckout).replace(queryParameters: {
      'billId': billId.toString(),
      'paymentMethodId': paymentMethodId.toString(),
    });

    final response = await http.put(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to checkout. Status code: ${response.statusCode}');
    }
  }
}
