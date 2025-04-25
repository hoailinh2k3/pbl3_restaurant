import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/repositories/bill_service.dart';

import '../../data/models/bill_model.dart';

extension ToUpsertJson on DanhSachMon {
  Map<String, dynamic> toUpsertJson() => {
        'foodId': foodId,
        'quantity': quantity,
        'description': description,
      };
}

class BillViewModel extends ChangeNotifier {
  int tableId = 0;
  int tableNumber = 0;
  int branchId = 0;
  bool isPayment = false;
  bool isSaving = false;
  bool isLoading = true;

  Map<int, BillModel> bills = {};
  final List<int> _removedBillItemIds = [];
  final BillService _service = BillService();

  Future<void> fetchBill() async {
    final local = bills[tableId];
    if (local == null) isLoading = true;
    if (local != null && local.billId == 0) {
      bills.remove(tableId);
    }
    try {
      final bill = await _service.fetchBill(tableId);
      if (bill != null) {
        bills[tableId] = bill;
      } else {
        print("VIEWMODEL → No bill found for table $tableId");
      }
    } catch (e) {
      print("VIEWMODEL → Error fetching bill: ${e.toString()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addLocalBillItem({
    required int foodId,
    required String picture,
    required String foodName,
    required int price,
    int quantity = 1,
    String description = '',
  }) {
    final bill = bills.putIfAbsent(
      tableId,
      () => BillModel(billId: 0, danhSachMon: []),
    );

    final idx = bill.danhSachMon.indexWhere((e) => e.foodId == foodId);
    if (idx != -1) {
      final existing = bill.danhSachMon[idx];
      existing.quantity += quantity;
      existing.subTotal = existing.price * existing.quantity;
    } else {
      // 3) Nếu chưa có thì thêm mới vào list
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      bill.danhSachMon.add(DanhSachMon(
        billItemId: tempId,
        foodId: foodId,
        picture: picture,
        foodName: foodName,
        price: price,
        quantity: quantity,
        description: description,
        subTotal: price * quantity,
      ));
    }

    notifyListeners();
  }

  void removeLocalBillItem(int billItemId) {
    bills[tableId]?.danhSachMon.removeWhere((e) => e.billItemId == billItemId);
    if (billItemId > 0) _removedBillItemIds.add(billItemId);
    notifyListeners();
  }

  void updateLocalDescription(int billItemId, String desc) {
    final bill = bills[tableId];
    if (bill == null) return;
    final idx = bill.danhSachMon.indexWhere((e) => e.billItemId == billItemId);
    if (idx == -1) return;
    bill.danhSachMon[idx].description = desc;
    notifyListeners();
  }

  Future<void> save(bool check) async {
    (check) ? isSaving = true : isPayment = true;
    notifyListeners();

    try {
      final items = bills[tableId]?.danhSachMon ?? [];
      // Gọi upsert một lần với toàn bộ mảng, dùng extension
      await _service.upsertFood(tableId, items);

      if (_removedBillItemIds.isNotEmpty) {
        await _service.deleteBillItem(_removedBillItemIds);
        _removedBillItemIds.clear();
      }
    } catch (e) {
      print("VIEWMODEL → Error saving bill: ${e.toString()}");
    } finally {
      (check) ? isSaving = false : isPayment = false;
      notifyListeners();
    }
  }

  void increaseQuantity(int billItemId) {
    final bill = bills[tableId];
    if (bill != null) {
      final item = bill.danhSachMon.firstWhere(
          (item) => item.billItemId == billItemId,
          orElse: () => DanhSachMon(
              billItemId: 0,
              foodId: 0,
              picture: "",
              foodName: "",
              price: 0,
              quantity: 0,
              description: "",
              subTotal: 0));
      item.quantity++;
      item.subTotal = item.price * item.quantity;
      notifyListeners();
    }
  }

  void decreaseQuantity(int billItemId) {
    final bill = bills[tableId];
    if (bill != null) {
      final item = bill.danhSachMon.firstWhere(
          (item) => item.billItemId == billItemId,
          orElse: () => DanhSachMon(
              billItemId: 0,
              foodId: 0,
              picture: "",
              foodName: "",
              price: 0,
              quantity: 0,
              description: "",
              subTotal: 0));
      item.quantity--;
      item.subTotal = item.price * item.quantity;
      notifyListeners();
    }
  }

  Future<bool> checkout(int paymentMethodId) async {
    isPayment = true;
    notifyListeners();
    try {
      final bill = bills[tableId];
      if (bill != null) {
        await _service.checkout(bill.billId, paymentMethodId);
        bills.remove(tableId);
      }
      return true;
    } catch (e, st) {
      print("VIEWMODEL → Error during checkout: $e");
      print(st);
      return false;
    } finally {
      isPayment = false;
      notifyListeners();
    }
  }

  int get totalPrice {
    return bills[tableId]
            ?.danhSachMon
            .fold(0, (sum, item) => sum! + item.subTotal) ??
        0;
  }
}
