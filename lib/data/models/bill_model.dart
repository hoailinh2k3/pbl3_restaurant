class BillModel {
  int billId;
  List<DanhSachMon> danhSachMon;

  BillModel({
    required this.billId,
    required this.danhSachMon,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
        billId: json["billId"],
        danhSachMon: List<DanhSachMon>.from(
            json["danhSachMon"].map((x) => DanhSachMon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "billId": billId,
        "danhSachMon": List<dynamic>.from(danhSachMon.map((x) => x.toJson())),
      };
}

class DanhSachMon {
  int billItemId;
  int foodId;
  String tenMon;
  int quantity;
  String description;
  int subTotal;

  DanhSachMon({
    required this.billItemId,
    required this.foodId,
    required this.tenMon,
    required this.quantity,
    required this.description,
    required this.subTotal,
  });

  factory DanhSachMon.fromJson(Map<String, dynamic> json) => DanhSachMon(
        billItemId: json["billItemId"],
        foodId: json["foodId"],
        tenMon: json["tenMon"],
        quantity: json["quantity"],
        description: json["description"] ?? "",
        subTotal: json["subTotal"],
      );

  Map<String, dynamic> toJson() => {
        "billItemId": billItemId,
        "foodId": foodId,
        "tenMon": tenMon,
        "quantity": quantity,
        "description": description,
        "subTotal": subTotal,
      };
}
