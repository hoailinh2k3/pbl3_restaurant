import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/core/helpers/asset_helper.dart';
import 'package:pbl3_restaurant/core/helpers/image_helper.dart';
import 'package:pbl3_restaurant/widgets/my_text_field.dart';
import 'package:pbl3_restaurant/widgets/my_button.dart';

import '../viewmodel/user_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String routeName = '/login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    final isLoading = vm.state == LoginState.loading;
    final size = MediaQuery.of(context).size;

    // Các widget con
    final children = [
      Expanded(
        flex: (size.width <= 750) ? 1 : 3,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: ImageHelper.loadFromAsset(AssetHelper.logo),
        ),
      ),
      Expanded(
        flex: 2,
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            color: ColorStyles.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight:
                  (size.width > 750) ? Radius.zero : const Radius.circular(25),
              bottomLeft:
                  (size.width <= 750) ? Radius.zero : const Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'ĐĂNG NHẬP',
                  style: TextStyles.title.bold
                      .getColor(ColorStyles.subText)
                      .getSize(40),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: 'Tài khoản',
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hintText: 'Mật khẩu',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Quên mật khẩu?',
                    style:
                        TextStyles.subscription.getColor(ColorStyles.subText),
                  ),
                ),
                const SizedBox(height: 20),
                // Nút hoặc loading
                if (isLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else ...[
                  MyButton(
                    onPressed: () async {
                      await vm.login(
                        _usernameController.text,
                        _passwordController.text,
                      );
                      if (vm.state == LoginState.success && vm.user != null) {
                        Navigator.pushReplacementNamed(context, '/main_page');
                      }
                    },
                    text: 'Đăng nhập',
                    color: ColorStyles.accent,
                    textStyle:
                        TextStyles.title.bold.getColor(ColorStyles.mainText),
                    heightPadding: 25,
                  ),
                ],
                const SizedBox(height: 16),
                if (vm.message.isNotEmpty) ...[
                  Text(
                    vm.message,
                    style: TextStyle(
                      color: vm.state == LoginState.success
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: ColorStyles.primary,
      body: (size.width <= 750)
          ? Column(children: children)
          : Row(children: children),
    );
  }
}
