import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../data/models/food_model.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../viewmodel/food_viewmodel.dart';

Future<void> showFoodDialog(BuildContext context, {FoodModel? food}) {
  final isEdit = food != null;
  final nameCtl = TextEditingController(text: food?.name ?? '');
  final priceCtl = TextEditingController(text: food?.price.toString() ?? '');
  final pictureCtl = TextEditingController(text: food?.picture ?? '');
  int? selectedCategoryId = food?.categoryId;
  var width = MediaQuery.of(context).size.width;

  final categories = context.read<CategoryViewModel>().categories;

  return showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx2, setState) {
        return AlertDialog(
          backgroundColor: ColorStyles.primary,
          content: SizedBox(
            width: width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Chỉnh sửa món ăn' : 'Thêm món ăn',
                  style: TextStyles.title,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Colors.grey[200],
                          child: pictureCtl.text.isNotEmpty
                              ? Image.network(
                                  pictureCtl.text,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: Colors.grey[200],
                                    height: 100,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Lỗi tải ảnh',
                                      style: TextStyle(
                                        color: ColorStyles.error,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.image,
                                        size: 50, color: ColorStyles.subText),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameCtl,
                            decoration: InputDecoration(
                              hintText: 'Tên món ăn',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Dropdown chọn danh mục
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  color: ColorStyles.mainText,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 250,
                                decoration: BoxDecoration(
                                  color: ColorStyles.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 4,
                                offset: Offset(0, 8),
                              ),
                              value: selectedCategoryId,
                              isExpanded: true,
                              items: categories.map((cat) {
                                return DropdownMenuItem<int>(
                                  value: cat.categoryId,
                                  child: Text(cat.categoryName,
                                      style: TextStyles.subscription),
                                );
                              }).toList(),
                              onChanged: (val) {
                                selectedCategoryId = val;
                                setState(() {});
                              },
                              hint: Text('Chọn danh mục',
                                  style: TextStyles.subscription),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: priceCtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Giá món ăn',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: pictureCtl,
                            onChanged: (val) {
                              pictureCtl.text = val;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Url ảnh',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Hủy',
                  style: TextStyles.subscription.getColor(ColorStyles.subText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.accent,
              ),
              onPressed: () {
                final name = nameCtl.text.trim();
                final price = int.tryParse(priceCtl.text.trim()) ?? 0;
                final pic = pictureCtl.text.trim();
                final catId = selectedCategoryId ?? 0;

                if (name.isEmpty || price <= 0 || catId == 0) {
                  return;
                }

                final vm = context.read<FoodViewModel>();
                if (isEdit) {
                  vm.updateFood(FoodModel(
                    foodId: food.foodId,
                    name: name,
                    categoryId: catId,
                    price: price,
                    picture: pic,
                  ));
                } else {
                  vm.addFood(FoodModel(
                    foodId: 0,
                    name: name,
                    categoryId: catId,
                    price: price,
                    picture: pic,
                  ));
                }
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Lưu',
                style: TextStyles.subscription.getColor(ColorStyles.mainText),
              ),
            ),
          ],
        );
      });
    },
  );
}
