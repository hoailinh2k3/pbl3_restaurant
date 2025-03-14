import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HelloUser(user: "{user}"),
        Expanded(
          child: Center(
            child: Text(
              'Thống kê',
              style: TextStyles.title.bold,
            ),
          ),
        ),
      ],
    );
  }
}
