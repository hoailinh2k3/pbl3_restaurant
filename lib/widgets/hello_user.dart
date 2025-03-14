import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';

class HelloUser extends StatelessWidget {
  final String user;

  HelloUser({required this.user});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào, $user',
                style: TextStyles.title.bold,
              ),
              Text(
                formattedDate,
                style: TextStyles.subscription,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
