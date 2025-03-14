import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/view/menu_page.dart';
import 'package:pbl3_restaurant/features/view/table_page.dart';
import 'package:pbl3_restaurant/features/viewmodel/home_page_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomePageViewModel>(context);
    return IndexedStack(
      index: vm.selectedIndex,
      children: [
        TablePage(onTableSelected: vm.selectNumber),
        MenuPage(
          table: vm.selectedNumber,
          onBack: vm.goBack,
        ),
      ],
    );
  }
}
