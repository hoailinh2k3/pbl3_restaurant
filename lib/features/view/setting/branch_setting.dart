import 'package:flutter/material.dart';
import 'package:pbl3_restaurant/features/view/setting/add_or_edit_branch.dart';
import 'package:pbl3_restaurant/features/viewmodel/branch_view_model.dart';
import 'package:pbl3_restaurant/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_styles.dart';
import '../../../core/constants/text_styles.dart';

class BranchSetting extends StatefulWidget {
  const BranchSetting({super.key});

  @override
  State<BranchSetting> createState() => _BranchSettingState();
}

class _BranchSettingState extends State<BranchSetting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<BranchViewModel>();
    vm.fetchBranches();
    var data = vm.branches;
    return Scaffold(
        backgroundColor: ColorStyles.secondary,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () => showBranchDialog(context),
              minWidth: 150,
              height: 150,
              color: ColorStyles.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add,
                color: ColorStyles.mainText,
                size: 50,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: 1,
              height: double.infinity,
              color: ColorStyles.subText,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: ColorStyles.primary,
                    child: InkWell(
                      onTap: () =>
                          showBranchDialog(context, branch: data[index]),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[200],
                              child: data[index].image.isEmpty
                                  ? Center(
                                      child: const Text(
                                        'Chưa có ảnh',
                                        style: TextStyle(
                                          color: ColorStyles.error,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      child: Image.network(
                                        data[index].image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (ctx, err, st) =>
                                            Container(
                                          color: Colors.grey[200],
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
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].branchName,
                                  style: TextStyles.title.bold,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: ColorStyles.mainText,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data[index].branchAddr,
                                      style: TextStyles.subscription,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      color: ColorStyles.mainText,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data[index].numberPhone,
                                      style: TextStyles.subscription,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            MaterialButton(
                              height: 50,
                              minWidth: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: ColorStyles.error,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(5),
                              onPressed: () => showConfirmDialog(
                                context,
                                itemName: "chi nhánh",
                                onConfirm: () {
                                  vm.deleteBranch(data[index].branchId);
                                },
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: ColorStyles.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
          ],
        ));
  }
}
