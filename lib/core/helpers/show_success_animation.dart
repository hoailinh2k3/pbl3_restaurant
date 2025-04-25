import 'package:flutter/material.dart';

import '../constants/color_styles.dart';

Future<void> showSuccessDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.of(ctx).pop();
      });
      return Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, scale, __) => Transform.scale(
            scale: scale,
            child: const Icon(Icons.check_circle,
                size: 80, color: ColorStyles.accent),
          ),
        ),
      );
    },
  );
}
