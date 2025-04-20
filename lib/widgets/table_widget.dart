import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/data/models/table_model.dart';

class TableWidget extends StatelessWidget {
  final TableModel table;
  final Function()? onTap;
  const TableWidget({super.key, required this.table, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MaterialButton(
          onPressed: onTap,
          color: table.statusName == "Đang sử dụng"
              ? ColorStyles.accent
              : ColorStyles.warning,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              'Bàn ${table.tableNumber}',
              style: TextStyles.title.bold.getColor(Colors.white),
            ),
          ),
        ),
        if (!(table.statusName == "Đang sử dụng"))
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: ColorStyles.subText,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Text(
                '${table.capacity} người',
                style: TextStyles.subscription.getColor(ColorStyles.primary),
              ),
            ),
          ),
      ],
    );
  }
}
