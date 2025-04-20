class CategoryModel {
  final int categoryId;
  final String categoryName;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
