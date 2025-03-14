import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'package:pbl3_restaurant/data/repositories/table_repository.dart';

class TablePageViewModel extends ChangeNotifier {
  TablePageViewModel() {
    getTable();
  }

  List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  getTable() async {
    var response = await TableRepository().readTables();
    if (_tables != response) {
      _tables = response;
      notifyListeners();
    }
  }
}
