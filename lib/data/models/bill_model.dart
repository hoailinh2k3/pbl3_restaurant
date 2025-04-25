class BillModel {
  int billId;
  List<DanhSachMon> danhSachMon;

  BillModel({
    required this.billId,
    required this.danhSachMon,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['danhSachMon'] as List<dynamic>?;

    return BillModel(
      billId: json['billId'] as int,
      danhSachMon: rawList != null
          ? rawList
              .map((e) => DanhSachMon.fromJson(e as Map<String, dynamic>))
              .toList()
          : <DanhSachMon>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'billId': billId,
        'danhSachMon': danhSachMon.map((x) => x.toJson()).toList(),
      };
}

class DanhSachMon {
  int billItemId;
  int foodId;
  String picture;
  String foodName;
  int price;
  int quantity;
  String description;
  int subTotal;

  DanhSachMon({
    required this.billItemId,
    required this.foodId,
    required this.picture,
    required this.foodName,
    required this.price,
    required this.quantity,
    required this.description,
    required this.subTotal,
  });

  factory DanhSachMon.fromJson(Map<String, dynamic> json) => DanhSachMon(
        billItemId: json["billItemId"],
        foodId: json["foodId"],
        picture: json["picture"],
        foodName: json["foodName"],
        price: json["price"],
        quantity: json["quantity"],
        description: json["description"] ?? "",
        subTotal: json["subTotal"],
      );

  Map<String, dynamic> toJson() => {
        "billItemId": billItemId,
        "foodId": foodId,
        "picture": picture,
        "foodName": foodName,
        "price": price,
        "quantity": quantity,
        "description": description,
        "subTotal": subTotal,
      };
}

extension ToUpsertJson on DanhSachMon {
  Map<String, dynamic> toUpsertJson() => {
        'foodId': foodId,
        'quantity': quantity,
        'description': description,
      };
}
