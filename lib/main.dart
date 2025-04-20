import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:pbl3_restaurant/core/routes/routes.dart';
import 'package:pbl3_restaurant/features/view/login_page.dart';
import 'package:pbl3_restaurant/features/viewmodel/category_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/food_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/main_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/menu_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/setting_page_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/table_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'features/viewmodel/bill_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.size = const Size(1280, 720);
      win.alignment = Alignment.center;
      win.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider chính, không phụ thuộc gì
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => MainPageViewModel()),
        ChangeNotifierProvider(create: (_) => MenuPageViewModel()),
        ChangeNotifierProvider(create: (_) => SettingPageViewmodel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => FoodViewModel()),
        ChangeNotifierProvider(create: (_) => BillViewModel()),
      ],
      // Dùng builder để đảm bảo có thể đọc UserViewModel
      builder: (context, child) {
        final userVM = Provider.of<UserViewModel>(context, listen: false);
        return ChangeNotifierProvider<TablePageViewModel>(
          create: (_) => TablePageViewModel(userViewModel: userVM),
          child: child,
        );
      },
      child: MaterialApp(
        title: 'PBL3 Restaurant',
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: LoginPage(),
      ),
    );
  }
}
