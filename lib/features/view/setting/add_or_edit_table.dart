import 'package:flutter/material.dart';
import '/features/viewmodel/table_page_view_model.dart';
import '/data/models/table_model.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';

Future<void> showTableDialog(BuildContext context, {TableModel? table}) {
  final nameCtl =
      TextEditingController(text: table?.tableNumber.toString() ?? '');
  final capacityCtl =
      TextEditingController(text: table?.capacity.toString() ?? '');
  final branchId =
      context.read<TablePageViewModel>().userViewModel.user!.branchId;
  var width = MediaQuery.of(context).size.width;

  return showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx2, setState) {
        return AlertDialog(
          backgroundColor: ColorStyles.primary,
          content: Container(
            width: width * 0.3,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table == null ? 'Thêm bàn' : 'Chỉnh sửa bàn',
                  style: TextStyles.title,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Số bàn',
                        style: TextStyles.subscription
                            .getColor(ColorStyles.mainText),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: nameCtl,
                        decoration: InputDecoration(
                          hintText: 'Số bàn',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Số lượng',
                        style: TextStyles.subscription
                            .getColor(ColorStyles.mainText),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: capacityCtl,
                        decoration: InputDecoration(
                          hintText: 'Số lượng người',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
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

                if (name.isEmpty) {
                  return;
                }

                final vm = context.read<TablePageViewModel>();
                if (table != null) {
                  vm.updateTable(TableModel(
                    tableId: table.tableId,
                    tableNumber: int.parse(name),
                    branchId: branchId,
                    statusName:
                        (table.statusName == "Đang sử dụng") ? "3" : "1",
                    capacity: int.parse(capacityCtl.text.trim()),
                  ));
                } else {
                  vm.addTable(TableModel(
                    tableId: 0,
                    tableNumber: int.parse(name),
                    branchId: branchId,
                    statusName: "1",
                    capacity: int.parse(capacityCtl.text.trim()),
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
