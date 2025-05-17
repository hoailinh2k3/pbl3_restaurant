import 'dart:async'; // ①
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/helpers/get_token.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'package:pbl3_restaurant/data/repositories/table_service.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';

class TablePageViewModel extends ChangeNotifier {
  final TableService tableService = TableService();
  final UserViewModel userViewModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  TablePageViewModel(this.userViewModel) {
    fetchTables();
  }

  Future<void> fetchTables() async {
    final branchId = userViewModel.user?.branchId;
    String token = await getToken();
    if (branchId == null) return;
    if (_tables.isEmpty) _isLoading = true;
    notifyListeners();
    try {
      final response = await tableService.fetchTables(branchId, token);
      if (_tables != response) {
        _tables = response;
      }
    } catch (e) {
      print("Error fetching tables: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTable(TableModel table) async {
    _tables.add(table);
    notifyListeners();
    try {
      String token = await getToken();
      await tableService.addTable(table, token);
    } catch (e) {
      print("Error adding table: $e");
      _tables.removeWhere((t) => t.tableId == table.tableId);
      notifyListeners();
    } finally {
      await fetchTables();
      notifyListeners();
    }
  }

  Future<void> updateTable(TableModel table) async {
    int index = _tables.indexWhere((t) => t.tableId == table.tableId);
    if (index != -1) {
      _tables[index] = table;
      notifyListeners();
    }
    try {
      String token = await getToken();
      await tableService.updateTable(table, token);
    } catch (e) {
      print("Error updating table: $e");
    } finally {
      await fetchTables();
      notifyListeners();
    }
  }

  Future<void> deleteTable(int tableId) async {
    int index = _tables.indexWhere((t) => t.tableId == tableId);
    if (index != -1) {
      String token = await getToken();
      _tables.removeAt(index);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    userViewModel.removeListener(fetchTables);
    super.dispose();
  }
}
