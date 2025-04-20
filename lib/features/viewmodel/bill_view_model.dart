import 'package:flutter/material.dart';

class BillViewModel extends ChangeNotifier {
  int tableNumber = 0;
  List orders = [];

  void fetchOrders() {
    // Logic to fetch orders from a repository or API
  }
}
