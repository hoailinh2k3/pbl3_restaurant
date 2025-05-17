import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/helpers/format_currency.dart';
import 'package:pbl3_restaurant/features/viewmodel/revenue_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/text_styles.dart';
import '../../../data/models/revenue.dart';

class BranchRevenueStatistics extends StatefulWidget {
  const BranchRevenueStatistics({super.key});

  @override
  State<BranchRevenueStatistics> createState() =>
      _BranchRevenueStatisticsState();
}

class _BranchRevenueStatisticsState extends State<BranchRevenueStatistics> {
  int? _touchedIndex;
  TimeRange selectedRange = TimeRange.Days;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevenueViewModel>().fetchRevenueByBranch(selectedRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<RevenueViewModel>();
    // Tính tổng doanh thu
    final total = vm.revenueByBranch.fold(0, (sum, e) => sum + e.total);
    var size = MediaQuery.of(context).size;

    return Card(
      clipBehavior: Clip.none,
      color: ColorStyles.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tổng doanh thu', style: TextStyles.subscription.bold),
                SizedBox(height: 5),
                Text("${formatCurrency(total)} đ",
                    style: TextStyles.title.bold),
              ],
            ),
            Expanded(
              flex: 5,
              child: LayoutBuilder(builder: (context, constraints) {
                final side = min(constraints.maxWidth, constraints.maxHeight);
                final data = vm.revenueByBranch;
                final colors = vm.branchColors;
                final isEmpty = data.isEmpty;
                return Center(
                  child: SizedBox(
                    width: side,
                    height: side,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            final desired = pieTouchResponse?.touchedSection;
                            setState(() {
                              if (desired != null &&
                                  !event.isInterestedForInteractions) {
                                _touchedIndex = null;
                              } else {
                                _touchedIndex = desired?.touchedSectionIndex;
                              }
                            });
                          },
                        ),
                        centerSpaceRadius: side * 0.3,
                        sectionsSpace: side * 0.02,
                        sections: isEmpty
                            ? [
                                PieChartSectionData(
                                  color: Colors.grey.shade300,
                                  value: 1,
                                  radius: side * 0.15,
                                  title: '',
                                ),
                              ]
                            : List.generate(data.length, (i) {
                                final isTouched = i == _touchedIndex;
                                final radius = side * (isTouched ? 0.22 : 0.15);
                                final color = isTouched
                                    ? colors[i]
                                    : colors[i].withOpacity(0.7);

                                return PieChartSectionData(
                                  color: color,
                                  value:
                                      total == 0 ? 0.0 : data[i].total / total,
                                  radius: radius,
                                  // khi hover mới show title
                                  title: isTouched
                                      ? formatCurrency(data[i].total)
                                      : '',
                                  titleStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  // căn title ở giữa mỗi section
                                  titlePositionPercentageOffset: 0.6,
                                );
                              }),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              width: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: ColorStyles.mainText,
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<TimeRange>(
                      dropdownColor: ColorStyles.primary,
                      value: selectedRange,
                      underline: SizedBox(),
                      items: TimeRange.values.map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Text(
                            r.label,
                            style: TextStyles.subscription,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          selectedRange = v;
                          vm.fetchRevenueByBranch(selectedRange);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.075 + size.width * 0.075),
                  ...List.generate(vm.revenueByBranch.length, (i) {
                    final b = vm.revenueByBranch[i];
                    final c = vm.branchColors[i];
                    final isLegendTouched = i == _touchedIndex;
                    return MouseRegion(
                      onEnter: (_) => setState(() => _touchedIndex = i),
                      onExit: (_) => setState(() => _touchedIndex = null),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            // dot màu, nếu hover thì viền sáng lên
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: isLegendTouched
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              b.name,
                              style: TextStyles.subscription.mainColor.copyWith(
                                fontWeight: isLegendTouched
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
