import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/core/helpers/format_currency.dart';
import 'package:pbl3_restaurant/features/viewmodel/revenue_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../../data/models/revenue.dart';
import '../../../data/repositories/revenue_service.dart';

class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  TimeRange _selectedRange = TimeRange.Days;
  late List<RevenuePoint> _data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RevenueViewModel>()
          .fetchRevenueByBranchandDate(1, _selectedRange);
    });
    _loadData();
  }

  void _loadData() {
    _data = RevenueService.fetchData(_selectedRange);
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<RevenueViewModel>();
    var userVm = context.read<UserViewModel>();
    final data = vm.revenue;
    final total =
        data.fold<int>(0, (sum, r) => sum + int.tryParse(r.total.toString())!);
    final maxY = data.isNotEmpty
        ? data.map((r) => double.tryParse(r.total.toString()) ?? 0).reduce(max)
        : 0.0;
    final roughStep =
        data.isNotEmpty ? maxY / 4 : 10000.0; // giống như trước để ko chia 0
    double niceStep(double value) {
      if (value <= 0 || value.isNaN || value.isInfinite) {
        return 1.0;
      }
      // pow trả về num, nên phải toDouble() để nó thành double
      final exp = pow(10, (log(value) / ln10).floor()).toDouble();
      final frac = value / exp;
      double niceFrac;

      if (frac < 1.5) {
        niceFrac = 1.0;
      } else if (frac < 3.0) {
        niceFrac = 2.0;
      } else if (frac < 7.0) {
        niceFrac = 5.0;
      } else {
        niceFrac = 10.0;
      }

      // niceFrac là double, exp là double, tích cũng là double
      return niceFrac * exp;
    }

    final step = niceStep(roughStep);
    final axisMax = data.isNotEmpty ? (maxY / step).ceil() * step : step;

    final spots = List.generate(data.length, (i) {
      final y = double.tryParse(data[i].total.toString()) ?? 0;
      return FlSpot(i.toDouble(), y);
    });

    return Card(
      color: ColorStyles.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Doanh thu',
                            style: TextStyles.subscription.bold,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz,
                                color: ColorStyles.subText),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${formatCurrency(total.round())} đ',
                              style: TextStyles.title.bold),
                          const Spacer(),
                          Container(
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
                              value: _selectedRange,
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
                                  _selectedRange = v;
                                  _loadData();
                                  vm.fetchRevenueByBranchandDate(
                                      userVm.user!.branchId, _selectedRange);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Biểu đồ line chart
            SizedBox(
              height: 300,
              child: (data.isEmpty)
                  ? const Center(
                      child: Text(
                      'Đang tải dữ liệu...',
                      style: TextStyles.subscription,
                    ))
                  : LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: axisMax,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: step,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: ColorStyles.subText,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: step,
                              reservedSize: 40,
                              getTitlesWidget: (value, TitleMeta meta) {
                                return Text(
                                  formatCurrencyShort(value.toInt()),
                                  style: TextStyle(
                                      color: ColorStyles.mainText,
                                      fontSize: 10),
                                  textAlign: TextAlign.end,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                if (idx < 0 || idx >= data.length) {
                                  return const SizedBox.shrink();
                                }
                                final label = data[idx].date;

                                return SideTitleWidget(
                                  meta: meta,
                                  space: 6,
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                        color: ColorStyles.mainText,
                                        fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            color: Colors.blueAccent,
                            barWidth: 2,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
