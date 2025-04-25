import 'dart:async'; // ①
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'package:pbl3_restaurant/data/repositories/table_service.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';

class TablePageViewModel extends ChangeNotifier {
  final TableService tableService;
  final UserViewModel userViewModel;

  List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  Timer? _pollTimer; // ②

  TablePageViewModel({
    required this.userViewModel,
    TableService? tableService,
  }) : tableService = tableService ?? TableService() {
    // Khi user login xong
    if (userViewModel.user != null) {
      fetchTables();
      _startAutoRefresh(); // ③
    }
    userViewModel.addListener(_onUserChanged);
  }

  void _onUserChanged() {
    if (userViewModel.user != null) {
      fetchTables();
      _startAutoRefresh(); // Bật lại khi user thay đổi/hết login
    } else {
      _stopAutoRefresh(); // Tắt polling khi logout
      _tables = [];
      notifyListeners();
    }
  }

  Future<void> fetchTables() async {
    final branchId = userViewModel.user!.branchId;
    try {
      final response = await tableService.fetchTables(branchId);
      if (_tables != response) {
        _tables = response;
        notifyListeners();
      }
    } catch (e) {
      // handle error nếu cần
    }
  }

  Future<void> addTable(TableModel table) async {
    _tables.add(table);
    notifyListeners();
    try {
      await tableService.addTable(table);
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
      await tableService.updateTable(table);
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
      _tables.removeAt(index);
      notifyListeners();
    }
  }

  void _startAutoRefresh() {
    // tránh tạo nhiều timer
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      Duration(milliseconds: 1),
      (_) => fetchTables(),
    );
  }

  void _stopAutoRefresh() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    userViewModel.removeListener(_onUserChanged);
    _stopAutoRefresh(); // ④
    super.dispose();
  }
}
