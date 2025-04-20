import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../widgets/my_button.dart';
import '../../viewmodel/menu_page_view_model.dart';
import '../../viewmodel/bill_view_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MenuPageViewModel>(context);
    var orderVM = context.watch<BillViewModel>();
    var size = MediaQuery.of(context).size;

    return Expanded(
      flex: (size.width <= 1200) ? ((vm.isPaid) ? 6 : 4) : 2,
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.primary,
          borderRadius: (size.width <= 1000)
              ? BorderRadius.zero
              : BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bàn #${orderVM.tableNumber}",
                          style: TextStyles.title.bold,
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text("Sản phẩm",
                                  style: TextStyles.subscription.bold),
                            ),
                            Spacer(),
                            Text(
                              "Số lượng",
                              style: TextStyles.subscription.bold,
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Giá",
                                style: TextStyles.subscription.bold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: ColorStyles.mainText,
                          thickness: 0.2,
                        ),
                      ],
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
                                      onPressed: () {},
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
                                        if (size.width <= 1000) {
                                          Navigator.pushNamed(
                                            context,
                                            '/payment_page',
                                          );
                                        } else {
                                          vm.updateIsPaid();
                                        }
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
}
