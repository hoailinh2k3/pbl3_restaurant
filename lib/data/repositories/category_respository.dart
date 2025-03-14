import 'package:pbl3_restaurant/data/models/category_model.dart';

class CategoryRespository {
  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: "Khai vị"),
    CategoryModel(id: 2, name: "Món chính"),
    CategoryModel(id: 3, name: "Tráng miệng"),
    CategoryModel(id: 4, name: "Đồ uống"),
    CategoryModel(id: 5, name: "Salad"),
  ];

  Future<List<CategoryModel>> readCategory() async {
    return _categories;
  }
}
