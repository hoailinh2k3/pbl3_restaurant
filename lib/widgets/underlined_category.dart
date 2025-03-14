import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';

class UnderlinedCategory extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool isSelected;
  final TextStyle? textStyle;
  final Color underlineColor;
  final double underlineThickness;
  final double spaceBetweenTextAndLine;

  const UnderlinedCategory({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.textStyle,
    this.underlineColor = ColorStyles.accent,
    this.underlineThickness = 2.0,
    this.spaceBetweenTextAndLine = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: TextStyles.subscription.bold),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textWidth = textPainter.size.width;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text hiển thị
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  text,
                  style: isSelected
                      ? TextStyles.subscription.bold
                          .getColor(ColorStyles.accent)
                      : TextStyles.subscription.bold
                          .getColor(ColorStyles.mainText),
                ),
              ),
            ),

            // Gạch chân nếu isSelected = true
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: spaceBetweenTextAndLine),
                width: textWidth,
                height: underlineThickness,
                decoration: BoxDecoration(
                  color: underlineColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        );
      },
    );
  }
}
