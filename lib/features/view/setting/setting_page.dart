import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/features/viewmodel/setting_page_viewmodel.dart';
import 'package:pbl3_restaurant/widgets/hello_user.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingPageViewmodel>(context);
    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: Column(
        children: [
          HelloUser(),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 180,
                width: 200,
                decoration: BoxDecoration(
                  color: ColorStyles.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: vm.settings.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        vm.isSelected = index;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        width: 200,
                        height: 40,
                        color: (vm.isSelected == index)
                            ? ColorStyles.mainText
                            : Colors.transparent,
                        child: Text(
                          vm.settings[index],
                          style: TextStyles.subscription.bold.getColor(
                              (vm.isSelected == index)
                                  ? ColorStyles.primary
                                  : ColorStyles.subText),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
