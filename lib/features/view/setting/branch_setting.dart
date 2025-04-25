import 'package:flutter/material.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';

class BranchSetting extends StatefulWidget {
  const BranchSetting({super.key});

  @override
  State<BranchSetting> createState() => _BranchSettingState();
}

class _BranchSettingState extends State<BranchSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: Center(
        child: Text(
          'Quản lý chi nhánh',
          style: TextStyles.title,
        ),
      ),
    );
  }
}
