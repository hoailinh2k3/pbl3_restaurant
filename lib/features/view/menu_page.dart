import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/features/viewmodel/menu_page_view_model.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:pbl3_restaurant/widgets/my_button.dart';
import 'package:pbl3_restaurant/widgets/payment_option.dart';
import 'package:pbl3_restaurant/widgets/underlined_category.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  final VoidCallback onBack;
  final int? table;
  const MenuPage({super.key, required this.table, required this.onBack});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MenuPageViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: menu(vm, width),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
        if (vm.isPaid)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => vm.updateIsPaid(),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(flex: vm.isPaid ? 1 : 2, child: Container()),
            orderPage(vm),
            if (vm.isPaid)
              Container(
                width: 0.5,
                color: ColorStyles.mainText,
                height: double.infinity,
              ),
            if (vm.isPaid) paymentPage(vm),
          ],
        ),
      ],
    );
  }

  Widget menu(MenuPageViewModel vm, double width) {
    return Column(
      children: [
        HelloUser(user: '{user}'),
        Row(
          children: [
            Spacer(),

            // Thanh tìm kiếm
            Container(
              width: 250,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: TextStyles.subscription, // Style của text nhập vào
                decoration: InputDecoration(
                  hintText: "Tìm kiếm món ăn, nước,...",
                  hintStyle: TextStyles.subscription, // Style của hint text
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
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Danh sách danh mục
        Container(
          height: 30,
          alignment: Alignment.topLeft,
          child: ListView.builder(
            itemCount: vm.categories.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: UnderlinedCategory(
                  text: vm.categories[index].name,
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
                  setState(() {
                    vm.selectedSort = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Danh sách món ăn
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            itemCount: 14,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width < 1200 ? 2 : (width < 1600 ? 3 : 4),
              crossAxisSpacing: 50,
              mainAxisSpacing: 20,
              childAspectRatio: 7 / 9,
            ),
            itemBuilder: (context, index) {
              final food = vm.foods[0];
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          food.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              food.name,
                              style: TextStyles.subscription,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Giá món ăn
                          Padding(
                            padding: const EdgeInsets.all(5),
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
          ),
        ),
      ],
    );
  }

  Widget orderPage(MenuPageViewModel vm) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorStyles.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: ColorStyles.mainText,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text('Tổng số tiền',
                                    style: TextStyles.subscription),
                                Spacer(),
                                Text(
                                  'Giá tiền',
                                  style: TextStyles.subscription.bold
                                      .getColor(ColorStyles.mainText),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            if (!vm.isPaid)
                              Row(
                                children: [
                                  Expanded(
                                    child: MyButton(
                                      onPressed: widget.onBack,
                                      color: ColorStyles.mainText,
                                      text: "Lưu",
                                      textStyle: TextStyles.title.bold
                                          .getColor(ColorStyles.accent),
                                      heightPadding: 15,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: MyButton(
                                      onPressed: () {
                                        vm.updateIsPaid();
                                      },
                                      color: ColorStyles.accent,
                                      text: "Thanh toán",
                                      textStyle: TextStyles.title.bold,
                                      heightPadding: 15,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget paymentPage(MenuPageViewModel vm) {
    return Expanded(
      flex: 1,
      child: Container(
        color: ColorStyles.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Thanh toán",
                          style: TextStyles.title.bold,
                        ),
                      ),
                      Divider(
                        color: ColorStyles.mainText,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Phương thức thanh toán",
                          style: TextStyles.title.bold,
                        ),
                      ),
                      Row(
                        children: [
                          PaymentOption(
                              icon: Icons.attach_money,
                              text: "Tiền mặt",
                              isSelected: vm.isMoney,
                              onTap: () {
                                vm.setMoney(true);
                              }),
                          SizedBox(width: 10),
                          PaymentOption(
                              icon: Icons.credit_card,
                              text: "Chuyển khoản",
                              isSelected: !vm.isMoney,
                              onTap: () {
                                vm.setMoney(false);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                MyButton(
                  onPressed: () {},
                  color: ColorStyles.accent,
                  text: "Thanh toán",
                  textStyle: TextStyles.title.bold,
                  heightPadding: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
