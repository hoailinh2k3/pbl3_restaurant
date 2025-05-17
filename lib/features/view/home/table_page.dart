import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/viewmodel/bill_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pbl3_restaurant/features/viewmodel/table_page_view_model.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:pbl3_restaurant/widgets/table_widget.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    final tableViewModel = context.watch<TablePageViewModel>();
    final orderViewModel = context.read<BillViewModel>();

    final tables = tableViewModel.tables;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        HelloUser(),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: tableViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: tables.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width <= 700 ? 3 : 5,
                      crossAxisSpacing: size.width <= 900 ? 20 : 70,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      final table = tables[index];
                      return TableWidget(
                        table: table,
                        onTap: () {
                          orderViewModel.tableNumber = table.tableNumber;
                          orderViewModel.tableId = table.tableId;
                          orderViewModel.branchId = table.branchId;
                          orderViewModel.fetchBill();
                          Navigator.pushNamed(
                            context,
                            '/menu_page',
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
