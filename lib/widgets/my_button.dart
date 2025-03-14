import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String text;
  final TextStyle textStyle;
  final double heightPadding;
  final void Function()? onPressed;

  MyButton({
    required this.onPressed,
    required this.color,
    required this.text,
    required this.textStyle,
    required this.heightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: heightPadding),
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
