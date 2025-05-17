import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/data/models/branch_model.dart';
import 'package:pbl3_restaurant/features/viewmodel/branch_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';

Future<void> showBranchDialog(BuildContext context, {BranchModel? branch}) {
  final nameCtl = TextEditingController(text: branch?.branchName ?? '');
  final addressCtl = TextEditingController(text: branch?.branchAddr ?? '');
  final phoneCtl = TextEditingController(text: branch?.numberPhone ?? '');
  final imageCtl = TextEditingController(text: branch?.image ?? '');
  var width = MediaQuery.of(context).size.width;

  return showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx2, setState) {
        return AlertDialog(
          backgroundColor: ColorStyles.primary,
          content: Container(
            width: width * 0.5,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch == null ? 'Thêm chi nhánh' : 'Chỉnh sửa chi nhánh',
                  style: TextStyles.title,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Colors.grey[200],
                          child: imageCtl.text.isNotEmpty
                              ? Image.network(
                                  imageCtl.text,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  errorBuilder: (ctx, err, st) => Container(
                                    color: Colors.grey[200],
                                    height: 100,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Lỗi tải ảnh',
                                      style: TextStyle(
                                        color: ColorStyles.error,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Icon(Icons.image,
                                        size: 50, color: ColorStyles.subText),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameCtl,
                            decoration: InputDecoration(
                              hintText: 'Tên chi nhánh',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: addressCtl,
                            decoration: InputDecoration(
                              hintText: 'Địa chỉ chi nhánh',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: phoneCtl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Số điện thoại chi nhánh',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: imageCtl,
                            onChanged: (val) {
                              imageCtl.text = val;
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'url ảnh',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Hủy',
                  style: TextStyles.subscription.getColor(ColorStyles.subText)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.accent,
              ),
              onPressed: () {
                final name = nameCtl.text.trim();
                final address = addressCtl.text.trim();
                final phone = phoneCtl.text.trim();
                final image = imageCtl.text.trim();

                if (name.isEmpty &&
                    address.isEmpty &&
                    phone.isEmpty &&
                    image.isEmpty &&
                    int.tryParse(phone) == null) {
                  return;
                }

                final vm = context.read<BranchViewModel>();
                if (branch != null) {
                  vm.updateBranch(
                    BranchModel(
                      branchId: branch.branchId,
                      branchName: name,
                      branchAddr: address,
                      numberPhone: phone,
                      image: image,
                    ),
                  );
                } else {
                  vm.addBranch(
                    BranchModel(
                      branchId: 0,
                      branchName: name,
                      branchAddr: address,
                      numberPhone: phone,
                      image: image,
                    ),
                  );
                }

                Navigator.of(ctx).pop();
              },
              child: Text(
                'Lưu',
                style: TextStyles.subscription.getColor(ColorStyles.mainText),
              ),
            ),
          ],
        );
      });
    },
  );
}
