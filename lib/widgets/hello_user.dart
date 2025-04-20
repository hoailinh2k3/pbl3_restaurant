import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:provider/provider.dart';

import '../features/viewmodel/user_view_model.dart';

class HelloUser extends StatelessWidget {
  const HelloUser({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<UserViewModel>();
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
                'Xin chào, ${vm.user?.fullName}',
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
