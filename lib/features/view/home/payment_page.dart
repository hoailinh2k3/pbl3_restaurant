import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/helpers/show_success_animation.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/payment_option.dart';
import '../../viewmodel/bill_view_model.dart';
import '../../viewmodel/menu_page_view_model.dart';
import '../../viewmodel/table_page_view_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MenuPageViewModel>(context);
    var billVm = Provider.of<BillViewModel>(context);
    var tableVm = Provider.of<TablePageViewModel>(context);

    return Container(
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
                    SizedBox(height: 10),
                    vm.isMoney ? moneyMethod() : transferMethod(),
                  ],
                ),
              ),
              (!billVm.isPayment)
                  ? MyButton(
                      onPressed: () async {
                        bool isSuccess = false;
                        if (vm.isMoney) {
                          isSuccess = await billVm.checkout(1);
                        } else {
                          isSuccess = await billVm.checkout(2);
                        }
                        if (isSuccess) {
                          tableVm.tables[billVm.tableId].statusName =
                              "Còn trống";
                          await showSuccessDialog(context);
                          vm.updateIsPaid();
                          Navigator.pushNamed(context, '/table_page');
                        }
                      },
                      color: ColorStyles.accent,
                      text: "Thanh toán",
                      textStyle: TextStyles.title.bold,
                      heightPadding: 15,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: ColorStyles.subText,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moneyMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Số tiền khách gửi: ', style: TextStyles.subscription),
        SizedBox(height: 10),
        MyTextField(
            hintText: 'Nhập số tiền', controller: TextEditingController()),
      ],
    );
  }

  Widget transferMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mã QR',
          style: TextStyles.subscription,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: ColorStyles.subText,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  'QR Code',
                  style: TextStyles.title.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
