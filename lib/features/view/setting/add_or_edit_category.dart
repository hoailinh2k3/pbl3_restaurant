import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';
import '../../../data/models/category_model.dart';
import '../../viewmodel/category_viewmodel.dart';

Future<void> showCategoryDialog(BuildContext context,
    {CategoryModel? category}) {
  final nameCtl = TextEditingController(text: category?.categoryName ?? '');
  var width = MediaQuery.of(context).size.width;

  return showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx2, setState) {
        return AlertDialog(
          backgroundColor: ColorStyles.primary,
          content: Container(
            width: width * 0.1,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == null ? 'Thêm danh mục' : 'Chỉnh sửa danh mục',
                  style: TextStyles.title,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameCtl,
                  decoration: InputDecoration(
                    hintText: 'Tên danh mục',
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

                if (name.isEmpty) {
                  return;
                }

                final vm = context.read<CategoryViewModel>();
                if (category != null) {
                  vm.updateCategory(CategoryModel(
                    categoryId: category.categoryId,
                    categoryName: name,
                  ));
                } else {
                  vm.addCategory(CategoryModel(
                    categoryId: 0,
                    categoryName: name,
                  ));
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
