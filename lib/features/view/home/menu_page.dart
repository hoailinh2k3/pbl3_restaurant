import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/data/models/category_model.dart';
import 'package:pbl3_restaurant/features/view/home/order_page.dart';
import 'package:pbl3_restaurant/features/view/home/payment_page.dart';
import 'package:pbl3_restaurant/features/viewmodel/category_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/food_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/menu_page_view_model.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:pbl3_restaurant/widgets/underlined_category.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuPageViewModel>(context);
    final categoryVm = Provider.of<CategoryViewModel>(context);
    final foodVm = Provider.of<FoodViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if ((_scaffoldKey.currentState?.isEndDrawerOpen == true && vm.isPaid) ||
            _scaffoldKey.currentState?.isEndDrawerOpen == true) {
          Navigator.of(context).pop();
          vm.setPaid(false);
        }
      });
    }
    if (width <= 1000) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if ((_scaffoldKey.currentState?.isEndDrawerOpen == false &&
                vm.isPaid) ||
            _scaffoldKey.currentState?.isEndDrawerOpen == false) {
          vm.setPaid(false);
        }
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorStyles.secondary,
      endDrawer: Drawer(
          child: Navigator(
        initialRoute: '/order_page',
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (settings.name) {
            case '/order_page':
              page = OrderPage();
              break;
            case '/payment_page':
              page = PaymentPage();
              break;
            default:
              page = OrderPage();
          }
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        },
      )),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: (width <= 1200) ? 3 : 4,
                child: menu(vm, categoryVm, foodVm, width),
              ),
              (width <= 1000)
                  ? SizedBox()
                  : Expanded(flex: 2, child: Container()),
            ],
          ),
          if (vm.isPaid && width > 1000)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => vm.updateIsPaid(),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          (width <= 1000)
              ? SizedBox()
              : Row(
                  children: [
                    Expanded(
                        flex: vm.isPaid ? 2 : ((width <= 1200) ? 6 : 4),
                        child: Container()),
                    OrderPage(),
                    if (vm.isPaid)
                      Container(
                        width: 0.5,
                        color: ColorStyles.mainText,
                        height: double.infinity,
                      ),
                    if (vm.isPaid) PaymentPage(),
                  ],
                ),
        ],
      ),
    );
  }

  Widget menu(MenuPageViewModel vm, CategoryViewModel cvm, FoodViewModel fvm,
      double width) {
    final displayedFoods = vm.getFilteredFoods(fvm.foods);
    return Column(
      children: [
        HelloUser(),
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
            (width <= 1000)
                ? IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    icon: Icon(Icons.menu, color: ColorStyles.mainText),
                  )
                : SizedBox(),
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
                  itemCount: displayedFoods.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width <= 675
                        ? 2
                        : (width <= 1000
                            ? 3
                            : (width > 1000 && width <= 1200)
                                ? 2
                                : (width <= 1400 ? 3 : 4)),
                    crossAxisSpacing: 50,
                    mainAxisSpacing: 20,
                    childAspectRatio: 7 / 9,
                  ),
                  itemBuilder: (context, index) {
                    final food = displayedFoods[index];
                    return Container(
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
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
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
                                  );
                                },
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    food.name,
                                    style: TextStyles.subscription,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Giá món ăn
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 5),
                                  child: Text(
                                    "${food.price.toStringAsFixed(0)} đ",
                                    style: TextStyles.subscription,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: ColorStyles.subText,
                  ),
                ),
        ),
      ],
    );
  }
}
