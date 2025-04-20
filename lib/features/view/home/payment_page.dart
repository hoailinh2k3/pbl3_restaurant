import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/payment_option.dart';
import '../../viewmodel/menu_page_view_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MenuPageViewModel>(context);
    var size = MediaQuery.of(context).size;

    return Expanded(
      flex: (size.width <= 1200) ? ((vm.isPaid) ? 6 : 4) : 2,
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
