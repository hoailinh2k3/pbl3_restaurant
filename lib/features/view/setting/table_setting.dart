import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/features/view/setting/add_or_edit_table.dart';
import 'package:pbl3_restaurant/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/text_styles.dart';
import '../../viewmodel/table_page_view_model.dart';

class TableSetting extends StatefulWidget {
  const TableSetting({super.key});

  @override
  State<TableSetting> createState() => _TableSettingState();
}

class _TableSettingState extends State<TableSetting> {
  @override
  Widget build(BuildContext context) {
    final tableViewModel = context.watch<TablePageViewModel>();

    final tables = tableViewModel.tables;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: tables.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.only(right: 20.0),
              itemCount: tables.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width <= 1500 ? 4 : 5,
                crossAxisSpacing: size.width <= 1500 ? 50 : 70,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return MaterialButton(
                    onPressed: () => showTableDialog(context),
                    color: ColorStyles.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side:
                          const BorderSide(color: ColorStyles.accent, width: 2),
                    ),
                    splashColor: ColorStyles.accent.withOpacity(0.5),
                    elevation: 0,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: ColorStyles.accent,
                        size: 50,
                      ),
                    ),
                  );
                }
                final table = tables[index - 1];
                return Stack(
                  children: [
                    MaterialButton(
                      onPressed: () => showTableDialog(context, table: table),
                      color: ColorStyles.accent,
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
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: ColorStyles.subText,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          '${table.capacity} người',
                          style: TextStyles.subscription
                              .getColor(ColorStyles.primary),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor:
                                  ColorStyles.primary.withOpacity(0.5),
                              shape: CircleBorder(),
                              hoverColor: ColorStyles.error.withOpacity(0.5)),
                          icon: Icon(Icons.delete, color: ColorStyles.error),
                          onPressed: () => showConfirmDialog(
                                context,
                                itemName: "bàn",
                                onConfirm: () {
                                  tableViewModel.deleteTable(table.tableId);
                                  Navigator.of(context).pop();
                                },
                              )),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
