import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/view/home/menu_page.dart';
import 'package:pbl3_restaurant/features/view/home/table_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/table_page',
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (settings.name) {
          case '/table_page':
            page = TablePage();
            break;
          case '/menu_page':
            page = MenuPage();
            break;
          default:
            page = TablePage();
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      },
    );
  }
}
