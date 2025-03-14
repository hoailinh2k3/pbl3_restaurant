import 'package:pbl3_restaurant/data/models/food_model.dart';

class FoodRespository {
  Future<List<FoodModel>> readFood() async {
    return _foods;
  }

  final List<FoodModel> _foods = [
    FoodModel(
      id: 0,
      name: "Bánh xèo",
      category: "Khai vị",
      price: 2000.00,
      image:
          "https://th.bing.com/th/id/R.b713bab209dbe252c10af3ca492f5cf1?rik=vsZ334md%2fHjIYg&riu=http%3a%2f%2fvietnam-online.org%2fwp-content%2fuploads%2f2020%2f07%2fbanh-xeo.jpg&ehk=nf0ryDwPGPBs5hHdlePdzKT0AUVM0ApNugD6xPBWVrM%3d&risl=&pid=ImgRaw&r=0",
    ),
  ];
}
