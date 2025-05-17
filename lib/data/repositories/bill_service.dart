import 'package:pbl3_restaurant/core/constants/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl3_restaurant/data/models/bill_model.dart';

// bill_service.dart
class BillService {
  Future<BillModel?> fetchBill(int tableId, String token) async {
    final uri = Uri.parse(Api.billList).replace(queryParameters: {
      'tableId': tableId.toString(),
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
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
        print('ERROR parse JSON in BillService: $e');
        print(st);
        rethrow;
      }
    } else {
      throw Exception(
          'Failed to load bill. Status code: ${response.statusCode}');
    }
  }

  Future<bool> upsertFood(
      int tableId, List<DanhSachMon> items, String token) async {
    final uri = Uri.parse('${Api.billUpsertFood}?tableId=$tableId');
    final payload = items.map((e) => e.toUpsertJson()).toList();

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to upsert foods. Status code: ${response.statusCode}');
    }
  }

  Future<bool> deleteBillItem(List<int> billItemId, String token) async {
    final uri = Uri.parse(Api.billDeleteFood);
    for (var i in billItemId) {
      print('item: $i');
    }

    final response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(billItemId),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to delete bill item. Status code: ${response.statusCode}');
    }
  }

  Future<Object?> checkout(
      int tableId, int paymentMethodId, int? money, String token) async {
    final uri = (paymentMethodId == 2)
        ? Uri.parse(Api.billCheckout).replace(queryParameters: {
            'tableId': tableId.toString(),
            'paymentMethodId': paymentMethodId.toString(),
          })
        : Uri.parse(Api.billCheckout).replace(queryParameters: {
            'tableId': tableId.toString(),
            'paymentMethodId': paymentMethodId.toString(),
            'tienKhachGui': money.toString(),
          });

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 && paymentMethodId == 2) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data')) {
          return QRCode.fromJson(jsonData['data']);
        } else {
          return null;
        }
      } catch (e, st) {
        print('ERROR parse JSON in BillService: $e');
        print(st);
        rethrow;
      }
    } else if (response.statusCode == 200 && paymentMethodId == 1) {
      return true;
    } else {
      throw Exception(
          'Failed to checkout. Status code: ${response.statusCode}, ${response.body}');
    }
  }
}
