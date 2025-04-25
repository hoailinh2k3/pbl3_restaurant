import 'package:flutter/material.dart';
import '../../core/constants/color_styles.dart';
import '../../core/constants/text_styles.dart';

Future<void> showConfirmDialog(
  BuildContext context, {
  required String itemName,
  required VoidCallback onConfirm,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: ColorStyles.primary,
        content: Text(
          'Bạn có chắc muốn xóa $itemName này không?',
          style: TextStyles.subscription,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Hủy',
              style: TextStyles.subscription.getColor(ColorStyles.subText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyles.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
            child: Text(
              'Xóa',
              style: TextStyles.subscription.getColor(ColorStyles.mainText),
            ),
          ),
        ],
      );
    },
  );
}
