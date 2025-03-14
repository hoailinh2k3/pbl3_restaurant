import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';

class PaymentOption extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  final String text;
  final IconData icon;

  const PaymentOption({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorStyles.mainText.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? ColorStyles.mainText : ColorStyles.subText,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color:
                      isSelected ? ColorStyles.mainText : ColorStyles.subText,
                  size: 20,
                ),
                Text(
                  text,
                  style: TextStyles.subscription.getColor(
                      isSelected ? ColorStyles.mainText : ColorStyles.subText),
                ),
              ],
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: ColorStyles.accent,
                borderRadius: BorderRadius.circular(90),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 7,
              ),
            ),
          ),
      ],
    );
  }
}
