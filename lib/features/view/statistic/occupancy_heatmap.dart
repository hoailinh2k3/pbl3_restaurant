import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/data/models/revenue.dart';
import 'package:pbl3_restaurant/features/viewmodel/revenue_view_model.dart';
import 'package:provider/provider.dart';

class OccupancyHeatmap extends StatefulWidget {
  const OccupancyHeatmap({super.key});

  @override
  State<OccupancyHeatmap> createState() => _OccupancyHeatmapState();
}

class _OccupancyHeatmapState extends State<OccupancyHeatmap> {
  String? _hoveredDay;
  int? _hoveredHour;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevenueViewModel>().fetchTableRates(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    final hours = [for (int h = 6; h < 22; h += 2) h];
    final vm = context.watch<RevenueViewModel>();

    final grouped = <String, Map<int, TableRates>>{};
    for (var d in days) {
      grouped[d] = {};
    }
    for (var item in vm.tableRates) {
      grouped[item.dayOfWeek]?[item.hour] = item;
    }

    Color colorForRatio(double r) {
      final t = (r.clamp(0, 100)) / 100;
      return Color.lerp(ColorStyles.secondary, ColorStyles.accent, t)!;
    }

    // Header row
    final headerRow = TableRow(
      children: [
        const SizedBox(), // ô góc
        for (var day in days)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              day.substring(0, 3),
              textAlign: TextAlign.center,
              style: TextStyles.subscription,
            ),
          ),
      ],
    );

    Color baseColor(double r) {
      final t = (r.clamp(0, 100)) / 100;
      return Color.lerp(ColorStyles.secondary, ColorStyles.accent, t)!;
    }

    Color lighten(Color c, [double amount = .1]) {
      final h = HSVColor.fromColor(c);
      final v = (h.value + amount).clamp(0.0, 1.0);
      return h.withValue(v).toColor();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorStyles.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Tỷ lệ sử dụng bàn",
                    style: TextStyles.title.bold,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      color: ColorStyles.mainText,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              (vm.tableRates.isEmpty)
                  ? Center(child: CircularProgressIndicator())
                  : ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: Table(
                        columnWidths: {
                          0: const FixedColumnWidth(40),
                          for (int i = 1; i <= days.length; i++)
                            i: const FlexColumnWidth(1),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,

                        // Các hàng giờ
                        children: [
                          for (var h in hours)
                            TableRow(
                              children: [
                                // Cột giờ
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text('${h}h',
                                      style: TextStyles.subscription,
                                      textAlign: TextAlign.end),
                                ),

                                // Các ô heatmap tương ứng mỗi ngày
                                for (var day in days)
                                  MouseRegion(
                                    onEnter: (_) => setState(() {
                                      _hoveredDay = day;
                                      _hoveredHour = h;
                                    }),
                                    onExit: (_) => setState(() {
                                      _hoveredDay = null;
                                      _hoveredHour = null;
                                    }),
                                    child: Container(
                                      height: 30,
                                      margin: const EdgeInsets.all(2),
                                      color: grouped[day]![h] != null
                                          ? ((_hoveredDay == day &&
                                                  _hoveredHour == h)
                                              ? lighten(baseColor(
                                                  grouped[day]![h]!.ratio))
                                              : baseColor(
                                                  grouped[day]![h]!.ratio))
                                          : Colors.grey[200],
                                      child: (_hoveredDay == day &&
                                              _hoveredHour == h)
                                          ? Center(
                                              child: Text(
                                                '${grouped[day]![h]!.ratio.toStringAsFixed(0)}%',
                                                style: TextStyles
                                                    .subscription.mainColor,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                              ],
                            ),

                          // Hàng cuối: ngày trong tuần
                          TableRow(
                            children: [
                              const SizedBox(),
                              for (var day in days)
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(day.substring(0, 3),
                                      textAlign: TextAlign.center,
                                      style: TextStyles.subscription),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
