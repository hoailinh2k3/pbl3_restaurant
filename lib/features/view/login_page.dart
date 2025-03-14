import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/core/helpers/asset_helper.dart';
import 'package:pbl3_restaurant/core/helpers/image_helper.dart';
import 'package:pbl3_restaurant/widgets/my_text_field.dart';
import 'package:pbl3_restaurant/widgets/my_button.dart';

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
    return Scaffold(
      backgroundColor: ColorStyles.primary,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: ImageHelper.loadFromAsset(AssetHelper.logo),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorStyles.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'ĐĂNG NHẬP',
                      style: TextStyles.title.bold
                          .getColor(ColorStyles.subText)
                          .getSize(40),
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      hintText: 'Tài khoản',
                      controller: _usernameController,
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      hintText: 'Mật khẩu',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyles.subscription
                            .getColor(ColorStyles.subText),
                      ),
                    ),
                    SizedBox(height: 20),
                    MyButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/main_page');
                      },
                      text: 'Đăng nhập',
                      color: ColorStyles.accent,
                      textStyle:
                          TextStyles.title.bold.getColor(ColorStyles.mainText),
                      heightPadding: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
