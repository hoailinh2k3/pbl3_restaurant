class TableModel {
  int tableId;
  int tableNumber;
  int capacity;
  String statusName;
  int branchId;

  TableModel({
    required this.tableId,
    required this.tableNumber,
    required this.capacity,
    required this.statusName,
    required this.branchId,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        tableId: json["tableId"],
        tableNumber: json["tableNumber"],
        capacity: json["capacity"],
        statusName: json["statusName"],
        branchId: json["branchId"],
      );

  Map<String, dynamic> toJson() => {
        "tableId": tableId,
        "tableNumber": tableNumber,
        "capacity": capacity,
        "statusName": statusName,
        "branchId": branchId,
      };
}
