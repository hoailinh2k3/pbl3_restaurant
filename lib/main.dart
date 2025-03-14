import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/routes/routes.dart';
import 'package:pbl3_restaurant/features/view/login_page.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:pbl3_restaurant/features/viewmodel/home_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/main_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/menu_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/table_page_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(1280, 720);
    win.size = const Size(1280, 720);
    win.alignment = Alignment.center;
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainPageViewModel()),
        ChangeNotifierProvider(create: (_) => TablePageViewModel()),
        ChangeNotifierProvider(create: (_) => MenuPageViewModel()),
        ChangeNotifierProvider(create: (_) => HomePageViewModel()),
      ],
      child: MaterialApp(
        title: 'PBL3 Restaurant',
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: LoginPage(),
      ),
    );
  }
}
