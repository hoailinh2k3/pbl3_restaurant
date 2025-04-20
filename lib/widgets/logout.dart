import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/color_styles.dart';
import '../features/viewmodel/user_view_model.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<UserViewModel>();
    return IconButton(
      onPressed: () {
        vm.logout();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login_page',
          (route) => false,
        );
      },
      icon: Icon(
        Icons.logout,
        color: ColorStyles.error,
      ),
    );
  }
}
