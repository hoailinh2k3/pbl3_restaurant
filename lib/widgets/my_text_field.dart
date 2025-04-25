import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool? obscureText;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: ColorStyles.subText),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
