import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/core/constants/color_styles.dart';
import 'package:pbl3_restaurant/core/constants/text_styles.dart';
import 'package:pbl3_restaurant/features/viewmodel/user_view_model.dart';
import 'package:pbl3_restaurant/widgets/my_button.dart';
import 'package:provider/provider.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();
    final size = MediaQuery.of(context).size;
    final fullName = userVM.user?.fullName ?? '';
    final phone = userVM.user?.phoneNumber ?? '';
    final birthday = userVM.user?.birthday != null
        ? '${userVM.user!.birthday.day}/${userVM.user!.birthday.month}/${userVM.user!.birthday.year}'
        : '';
    final gender = userVM.user?.gender ?? '';

    return Scaffold(
      backgroundColor: ColorStyles.secondary,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin tài khoản
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            width: size.width * 0.4,
            decoration: BoxDecoration(
              color: ColorStyles.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.3 * 0.4,
                  height: size.width * 0.4 * 0.4,
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: (userVM.user?.picture != null)
                      ? Image.network(
                          userVM.user!.picture,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'Lỗi tải ảnh',
                              style: TextStyle(
                                color: ColorStyles.error,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        )
                      : const Text(
                          'Chưa có ảnh',
                          style: TextStyle(
                            color: ColorStyles.error,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInfoItem('Họ tên:', fullName),
                        const SizedBox(height: 10),
                        _buildInfoItem('Số điện thoại:', phone),
                        const SizedBox(height: 10),
                        _buildInfoItem('Ngày sinh:', birthday),
                        const SizedBox(height: 10),
                        _buildInfoItem('Giới tính:', gender),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            width: size.width * 0.15,
            child: Column(
              children: [
                MyButton(
                  onPressed: () {},
                  color: ColorStyles.mainText,
                  text: 'Lưu thông tin',
                  textStyle:
                      TextStyles.subscription.getColor(ColorStyles.accent),
                  heightPadding: 15,
                ),
                const SizedBox(height: 15),
                MyButton(
                  onPressed: () {},
                  color: ColorStyles.accent,
                  text: 'Đổi mật khẩu',
                  textStyle:
                      TextStyles.subscription.getColor(ColorStyles.mainText),
                  heightPadding: 15,
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildInfoItem(String title, String value) {
    final ctl = _controllers.putIfAbsent(
        title, () => TextEditingController(text: value));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(title,
              style: TextStyles.subscription, textAlign: TextAlign.end),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 30,
            child: TextField(
              controller: ctl,
              style: TextStyles.subscription,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
