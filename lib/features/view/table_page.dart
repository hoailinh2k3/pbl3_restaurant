import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/viewmodel/table_page_view_model.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:pbl3_restaurant/widgets/table_widget.dart';
import 'package:provider/provider.dart';

class TablePage extends StatefulWidget {
  final Function(int) onTableSelected;
  const TablePage({super.key, required this.onTableSelected});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    final tableViewModel = Provider.of<TablePageViewModel>(context);
    return Column(
      children: [
        HelloUser(user: "{user}"),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: tableViewModel.tables.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 70.0,
                mainAxisSpacing: 20.0,
              ),
              itemBuilder: (context, index) {
                return TableWidget(
                  table: tableViewModel.tables[index],
                  onTap: () {
                    widget.onTableSelected(tableViewModel.tables[index].number);
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
