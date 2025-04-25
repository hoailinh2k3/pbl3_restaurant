import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/helpers/format_currency.dart';
import '../../../data/models/category_model.dart';
import '../../../widgets/alert_dialog.dart';
import '../../../widgets/underlined_category.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../viewmodel/food_viewmodel.dart';
import '../../viewmodel/menu_page_view_model.dart';
import 'add_or_edit_category.dart';
import 'add_or_edit_food.dart';

class FoodSetting extends StatefulWidget {
  const FoodSetting({super.key});

  @override
  State<FoodSetting> createState() => _FoodSettingState();
}

class _FoodSettingState extends State<FoodSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: menu()),
          Container(
            width: 1,
            height: double.infinity,
            color: ColorStyles.mainText,
          ),
          Expanded(flex: 2, child: category()),
        ],
      ),
    );
  }

  Widget category() {
    var cvm = context.watch<CategoryViewModel>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Danh mục", style: TextStyles.title.bold),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cvm.categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: ColorStyles.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      trailing: Icon(Icons.add, color: ColorStyles.accent),
                      title:
                          Text("Thêm danh mục", style: TextStyles.subscription),
                      onTap: () {
                        showCategoryDialog(context);
                      },
                    ),
                  );
                }

                final cat = cvm.categories[index - 1];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      showCategoryDialog(context, category: cat);
                    },
                    child: ListTile(
                      title: Text(cat.categoryName,
                          style: TextStyles.subscription),
                      trailing: InkWell(
                        onTap: () => showConfirmDialog(
                          context,
                          itemName: "danh mục",
                          onConfirm: () {
                            cvm.deleteCategory(cat.categoryId);
                          },
                        ),
                        child: Icon(Icons.delete, color: ColorStyles.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget menu() {
    var fvm = context.watch<FoodViewModel>();
    var cvm = context.watch<CategoryViewModel>();
    var vm = context.watch<MenuPageViewModel>();
    final width = MediaQuery.of(context).size.width;
    var displayedFoods = vm.getFilteredFoods(fvm.foods);
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            // Thanh tìm kiếm
            Container(
              width: 250,
              margin: (width <= 1000)
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: TextStyles.subscription,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm món ăn, nước,...",
                  hintStyle: TextStyles.subscription,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
                ),
                onChanged: (value) {
                  vm.setSearchQuery(value);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Danh sách danh mục
        Container(
          height: 30,
          padding: EdgeInsets.only(left: 20.0),
          alignment: Alignment.topLeft,
          child: ListView.builder(
            itemCount: cvm.categories.length + 1,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              List<CategoryModel> displayCategories = [
                CategoryModel(categoryId: 0, categoryName: "Tất cả"),
                ...cvm.categories
              ];
              return Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: UnderlinedCategory(
                  text: displayCategories[index].categoryName,
                  isSelected: (vm.selectedCategory == index),
                  onTap: () {
                    vm.selectedCategory = index;
                  },
                ),
              );
            },
          ),
        ),

        // Text "Chọn món" và sắp xếp
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chọn món", style: TextStyles.title.bold),
              DropdownButton2<String>(
                underline: SizedBox(),
                alignment: Alignment.center,
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 40,
                  width: 130,
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                hint: Text(
                  "Sắp xếp",
                  style: TextStyles.subscription,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                  ),
                ),

                // Tạo danh sách các item từ sortOptions
                items: vm.sortOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyles.subscription,
                    ),
                  );
                }).toList(),
                value: vm.selectedSort,
                onChanged: (value) {
                  vm.selectedSort = value;
                },
              ),
            ],
          ),
        ),

        // Danh sách món ăn
        Expanded(
          child: (!fvm.isLoading)
              ? GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  itemCount: displayedFoods.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (width <= 1200 ? 2 : (width <= 1400 ? 3 : 4)),
                    crossAxisSpacing: 35,
                    mainAxisSpacing: 20,
                    childAspectRatio: 7 / 9,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () => showFoodDialog(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorStyles.primary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorStyles.accent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(Icons.add,
                                size: 50, color: ColorStyles.accent),
                          ),
                        ),
                      );
                    }

                    final food = displayedFoods[index - 1];
                    return InkWell(
                      onTap: () => showFoodDialog(context, food: food),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorStyles.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Ảnh món ăn
                                Expanded(
                                  flex: 5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    child: Image.network(
                                      food.picture,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (ctx, err, st) => Container(
                                        color: Colors.grey[200],
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
                                    ),
                                  ),
                                ),
                                // Tên & Giá
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          food.name,
                                          style: TextStyles.subscription,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "${formatCurrency(food.price)}đ",
                                          style: TextStyles.subscription,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor:
                                        ColorStyles.primary.withOpacity(0.5),
                                    shape: CircleBorder(),
                                    hoverColor:
                                        ColorStyles.error.withOpacity(0.5)),
                                icon: Icon(Icons.delete,
                                    color: ColorStyles.error),
                                onPressed: () => showConfirmDialog(
                                      context,
                                      itemName: "món ăn",
                                      onConfirm: () {
                                        fvm.deleteFood(food.foodId);
                                      },
                                    )),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(color: ColorStyles.subText),
                ),
        ),
      ],
    );
  }
}
