import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';

class TextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    color: ColorStyles.mainText,
  );

  static const TextStyle subscription = TextStyle(
    fontSize: 15,
    color: ColorStyles.subText,
  );
}

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w500);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get mainColor => copyWith(color: ColorStyles.mainText);

  TextStyle get subColor => copyWith(color: ColorStyles.subText);

  TextStyle getColor(Color color) => copyWith(color: color);

  TextStyle getSize(double size) => copyWith(fontSize: size);
}

// How to use:
// Text('Hello, World!', style: TextStyles.title.bold.getColor(Colors.red),);
// Text('Hello, World!', style: TextStyles.subscription.getSize(10),);
// Text('Hello, World!', style: TextStyles.title.bold.getColor(Colors.red).getSize(20),);
