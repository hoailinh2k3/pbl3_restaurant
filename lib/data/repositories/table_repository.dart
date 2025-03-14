import 'package:pbl3_restaurant/data/models/table_model.dart';

class TableRepository {
  final List<TableModel> _tables = [
    TableModel(id: 1, number: 1, capacity: 4, status: false),
    TableModel(id: 2, number: 2, capacity: 2, status: true),
    TableModel(id: 3, number: 3, capacity: 6, status: false),
    TableModel(id: 4, number: 4, capacity: 4, status: true),
    TableModel(id: 5, number: 5, capacity: 8, status: false),
    TableModel(id: 6, number: 6, capacity: 2, status: true),
    TableModel(id: 7, number: 7, capacity: 4, status: false),
    TableModel(id: 8, number: 8, capacity: 6, status: true),
    TableModel(id: 9, number: 9, capacity: 4, status: false),
    TableModel(id: 10, number: 10, capacity: 2, status: true),
    TableModel(id: 11, number: 11, capacity: 6, status: false),
    TableModel(id: 12, number: 12, capacity: 4, status: true),
    TableModel(id: 13, number: 13, capacity: 8, status: false),
    TableModel(id: 14, number: 14, capacity: 2, status: true),
    TableModel(id: 15, number: 15, capacity: 4, status: false),
    TableModel(id: 16, number: 16, capacity: 6, status: true),
  ];

  Future<List<TableModel>> readTables() async {
    return _tables;
  }
}
