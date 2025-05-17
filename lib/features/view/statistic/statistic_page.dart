import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/features/view/statistic/revenue_page.dart';
import 'package:pbl3_restaurant/features/view/statistic/top_foods_page.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:provider/provider.dart';

import 'branch_revenue_page.dart';
import 'occupancy_heatmap.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    var vm = context.read<UserViewModel>();
    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HelloUser(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // if (vm.user?.role == "Quản lý tổng")
                        BranchRevenueStatistics(),
                        SizedBox(height: 20),
                        // Tạo cho mình một heatmap
                        OccupancyHeatmap(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          RevenueChart(),
                          TopFoodsPage(),
                        ],
                      ),
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
}
