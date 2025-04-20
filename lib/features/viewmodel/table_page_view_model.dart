import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';
import 'package:pbl3_restaurant/data/repositories/table_service.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';

class TablePageViewModel extends ChangeNotifier {
  final TableService tableService;
  final UserViewModel userViewModel;

  TablePageViewModel({
    required this.userViewModel,
    TableService? tableService,
  }) : tableService = tableService ?? TableService() {
    if (userViewModel.user != null) {
      fetchTables();
    }
    userViewModel.addListener(_onUserChanged);
  }

  void _onUserChanged() {
    if (userViewModel.user != null) {
      fetchTables();
    } else {
      _tables = [];
      notifyListeners();
    }
  }

  List<TableModel> _tables = [];
  List<TableModel> get tables => _tables;

  Future<void> fetchTables() async {
    final branchId = userViewModel.user!.branchId;
    final response = await tableService.fetchTables(branchId);
    if (_tables != response) {
      _tables = response;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    userViewModel.removeListener(_onUserChanged);
    super.dispose();
  }
}
