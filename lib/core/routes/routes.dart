import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/view/login_page.dart';
import 'package:pbl3_restaurant/features/view/main_page.dart';

final Map<String, WidgetBuilder> routes = {
  LoginPage.routeName: (context) => const LoginPage(),
  MainPage.routeName: (context) => const MainPage(),
};
