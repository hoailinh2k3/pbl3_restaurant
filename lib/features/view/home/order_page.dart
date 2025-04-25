import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/bill_model.dart';
import 'package:pbl3_restaurant/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/helpers/format_currency.dart';
import '../../../widgets/my_button.dart';
import '../../viewmodel/menu_page_view_model.dart';
import '../../viewmodel/bill_view_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final Map<int, TextEditingController> _noteControllers = {};

  @override
  void dispose() {
    for (var ctl in _noteControllers.values) {
      ctl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MenuPageViewModel>(context);
    var billVM = context.watch<BillViewModel>();
    var size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.primary,
        borderRadius: (size.width <= 1000)
            ? BorderRadius.zero
            : BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
      ),
      child: AbsorbPointer(
        absorbing: vm.isPaid,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bàn #${billVM.tableNumber}",
                      style: TextStyles.title.bold,
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text("Sản phẩm",
                              style: TextStyles.subscription.bold),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Số lượng",
                            style: TextStyles.subscription.bold,
                            textAlign: TextAlign.center,
                          ),
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
                    Expanded(
                      child: (billVM.isLoading)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: billVM.bills[billVM.tableId]
                                      ?.danhSachMon.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final item = billVM
                                    .bills[billVM.tableId]!.danhSachMon[index];
                                final ctl = _noteControllers.putIfAbsent(
                                  item.billItemId,
                                  () => TextEditingController(
                                      text: item.description),
                                );
                                return billItem(item, ctl);
                              },
                            ),
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
                              '${formatCurrency(billVM.totalPrice)}đ',
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
                                child: (!billVM.isSaving)
                                    ? MyButton(
                                        onPressed: () async {
                                          await billVM.save(true);
                                          Navigator.pushNamed(
                                            context,
                                            '/table_page',
                                          );
                                        },
                                        color: ColorStyles.mainText,
                                        text: "Lưu",
                                        textStyle: TextStyles.title.bold
                                            .getColor(ColorStyles.accent),
                                        heightPadding: 15,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: ColorStyles.subText,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: (!billVM.isPayment)
                                    ? MyButton(
                                        onPressed: () async {
                                          await billVM.save(false);
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
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: ColorStyles.subText,
                                        ),
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
        ),
      ),
    );
  }

  Widget billItem(DanhSachMon item, TextEditingController ctl) {
    var billVM = Provider.of<BillViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        item.picture,
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
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.foodName,
                            style: TextStyles.subscription,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${formatCurrency(item.price)}đ',
                            style: TextStyles.subscription
                                .getColor(ColorStyles.subText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // nút giảm
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          if (item.quantity > 1) {
                            billVM.decreaseQuantity(item.billItemId);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorStyles.subText,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: ColorStyles.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorStyles.mainText,
                        ),
                        child: Text(
                          item.quantity.toString().padLeft(2, '0'),
                          style: TextStyles.subscription
                              .getColor(ColorStyles.primary),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          billVM.increaseQuantity(item.billItemId);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorStyles.subText,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: ColorStyles.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  formatCurrency(item.subTotal),
                  style: TextStyles.subscription,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: MyTextField(
                  hintText: 'Ghi chú...',
                  controller: ctl,
                  onChanged: (val) {
                    billVM.updateLocalDescription(item.billItemId, val);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    billVM.removeLocalBillItem(item.billItemId);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorStyles.error, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.delete_outline, color: ColorStyles.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
