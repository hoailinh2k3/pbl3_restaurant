import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:provider/provider.dart';

import '../features/viewmodel/branch_view_model.dart';
import '../features/viewmodel/user_view_model.dart';

class HelloUser extends StatefulWidget {
  const HelloUser({super.key});

  @override
  State<HelloUser> createState() => _HelloUserState();
}

class _HelloUserState extends State<HelloUser> {
  @override
  Widget build(BuildContext context) {
    var userVM = context.watch<UserViewModel>();
    var branchVM = context.watch<BranchViewModel>();
    String formattedDate =
        DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xin chào, ${userVM.user?.fullName}',
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
