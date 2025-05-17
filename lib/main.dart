import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:pbl3_restaurant/core/routes/routes.dart';
import 'package:pbl3_restaurant/features/view/login_page.dart';
import 'package:pbl3_restaurant/features/viewmodel/category_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/food_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/main_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/menu_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/revenue_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/setting_page_viewmodel.dart';
import 'package:pbl3_restaurant/features/viewmodel/table_page_view_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

import 'features/viewmodel/bill_view_model.dart';
import 'features/viewmodel/branch_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  if (!kIsWeb) {
    doWhenWindowReady(() {
      final win = appWindow;
      win.size = const Size(1280, 720);
      win.minSize = const Size(1280, 720);
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
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => RevenueViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, MainPageViewModel>(
          create: (_) => MainPageViewModel(),
          update: (_, userVM, mainVM) {
            mainVM!.updateUser(userVM.user);
            return mainVM;
          },
        ),
        ChangeNotifierProxyProvider<UserViewModel, TablePageViewModel>(
          create: (context) => TablePageViewModel(UserViewModel()),
          update: (_, userVM, previous) {
            return TablePageViewModel(userVM);
          },
        ),
        ChangeNotifierProvider(create: (_) => MenuPageViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, SettingPageViewmodel>(
          create: (_) => SettingPageViewmodel(),
          update: (_, userVM, settingVM) {
            settingVM!.updateUser(userVM.user);
            return settingVM;
          },
        ),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => FoodViewModel()),
        ChangeNotifierProvider(create: (_) => BillViewModel()),
        ChangeNotifierProvider(create: (_) => BranchViewModel()),
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
