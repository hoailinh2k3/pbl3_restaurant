import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HelloUser(user: "{user}"),
        Expanded(
          child: Center(
            child: Text(
              'Thiết lập',
              style: TextStyles.title.bold,
            ),
          ),
        ),
      ],
    );
  }
}
