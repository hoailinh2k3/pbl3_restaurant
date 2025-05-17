import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/data/models/revenue.dart';
import 'package:pbl3_restaurant/features/viewmodel/revenue_view_model.dart';
import 'package:provider/provider.dart';

class TopFoodsPage extends StatefulWidget {
  const TopFoodsPage({super.key});

  @override
  State<TopFoodsPage> createState() => _TopFoodsPageState();
}

class _TopFoodsPageState extends State<TopFoodsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RevenueViewModel>().fetchTopFoodsByBranch(1);
      context.read<RevenueViewModel>().fetchBottomFoodsByBranch(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<RevenueViewModel>();
    final top = vm.topFoodsByBranch;
    final bottom = vm.bottomFoodsByBranch;

    return Row(
      children: [
        Expanded(child: topAndBottom(vm, top, 'Bán chạy')),
        const SizedBox(),
        Expanded(child: topAndBottom(vm, bottom, 'Bán ế')),
      ],
    );
  }

  Card topAndBottom(RevenueViewModel vm, List<TopFoods> data, String label) {
    return Card(
      color: ColorStyles.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyles.title.bold),
            const SizedBox(height: 10),

            // Nếu chưa có dữ liệu
            if (vm.topFoodsByBranch.isEmpty)
              Center(
                  child: Text('Đang tải...', style: TextStyles.subscription)),

            // Biểu đồ
            if (vm.topFoodsByBranch.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            data[index].picture,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Text(
                                  'Lỗi tải ảnh',
                                  style: TextStyle(
                                    color: ColorStyles.error,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        data[index].name,
                        style: TextStyles.subscription.mainColor,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        "Số lượng: ${data[index].quantity}",
                        style: TextStyles.subscription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
