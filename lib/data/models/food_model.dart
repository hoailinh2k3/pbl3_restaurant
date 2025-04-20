class FoodModel {
  int foodId;
  String name;
  int categoryId;
  int price;
  String picture;

  FoodModel({
    required this.foodId,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.picture,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        foodId: json["foodId"] ?? 0,
        name: json["foodName"] ?? "",
        categoryId: json["categoryId"] ?? 0,
        price: json["price"] as int,
        picture: json["picture"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "name": name,
        "categoryId": categoryId,
        "price": price,
        "picture": picture,
      };
}
