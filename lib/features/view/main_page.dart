import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/core/helpers/asset_helper.dart';
import 'package:pbl3_restaurant/core/helpers/image_helper.dart';
import 'package:pbl3_restaurant/features/viewmodel/main_page_view_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/logout.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static String routeName = '/main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainPageViewModel>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: Row(
        children: [
          SizedBox(
            width: size.width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorStyles.primary,
                        borderRadius: viewModel.previousIndex == -1
                            ? BorderRadius.only(
                                bottomRight: Radius.circular(20),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ImageHelper.loadFromAsset(AssetHelper.logo),
                      ),
                    ),
                    railNavigator(),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorStyles.primary,
                            borderRadius: viewModel.postIndex ==
                                    viewModel.railItems.length
                                ? BorderRadius.only(
                                    topRight: Radius.circular(20),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        color: ColorStyles.primary,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Logout(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: viewModel.pages[viewModel.currentIndex],
          ),
        ],
      ),
    );
  }

  Widget railNavigator() {
    final viewModel = Provider.of<MainPageViewModel>(context);
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: viewModel.railItems.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: viewModel.currentIndex == index
                ? ColorStyles.secondary
                : ColorStyles.primary,
            borderRadius:
                viewModel.previousIndex == index || viewModel.postIndex == index
                    ? BorderRadius.only(
                        topRight: viewModel.postIndex == index
                            ? Radius.circular(20)
                            : Radius.zero,
                        bottomRight: viewModel.previousIndex == index
                            ? Radius.circular(20)
                            : Radius.zero,
                      )
                    : null,
          ),
          child: Container(
            padding: viewModel.currentIndex == index
                ? const EdgeInsets.symmetric(vertical: 10)
                : null,
            decoration: viewModel.currentIndex == index
                ? BoxDecoration(
                    color: ColorStyles.accent,
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    viewModel.updateIndex(index);
                  },
                  icon: Icon(
                    viewModel.railItems[index]['icon'],
                    color: viewModel.currentIndex == index
                        ? ColorStyles.mainText
                        : ColorStyles.subText,
                  ),
                ),
                (viewModel.currentIndex == index && width >= 1200)
                    ? Text(
                        viewModel.railItems[index]['title'],
                        style: TextStyles.subscription.bold
                            .getColor(ColorStyles.mainText),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
