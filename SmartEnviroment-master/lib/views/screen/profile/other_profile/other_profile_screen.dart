import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/routes/app_pages.dart';

import '../../../../services/commons/constants.dart';
import '../components/history_pollution.dart';
import '../components/profile_pic.dart';
import '../components/ui_two_text_line.dart';
import '../../../../controllers/other_profile_controller.dart';

class OtherProfileScreen extends StatelessWidget {
  late final OtherProfileController _controller =
      Get.put(OtherProfileController());

  OtherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ thành viên"), actions: <Widget>[
        Obx(() => _controller.currentUser.value?.role == "admin"
            ? PopupMenuButton<String>(
                onSelected: handleClickMenu,
                itemBuilder: (BuildContext context) {
                  return {'Xóa', 'Chỉnh sửa'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            : Container())
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: [
            Obx(() => ProfilePic(
                  user: _controller.user.value,
                )),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                _controller.user.value?.name ?? "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(_controller.user.value?.email ?? "")),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                children: [
                  const Spacer(),
                  TwoTextLine(
                      textOne:
                          "${_controller.pollution.value?.totalResults ?? 0}",
                      textTwo: "Số báo cáo"),
                  const Spacer(),
                  TwoTextLine(
                      textOne: _controller.user.value?.role == kRoleAdmin
                          ? "Quản trị viên"
                          : _controller.user.value?.role == kRoleMod
                              ? "Kiểm duyệt"
                              : "Thành viên",
                      textTwo: "Chức vụ"),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 1,
            ),
            const SizedBox(height: 20),
            const Text(
              "Lịch sử báo cáo gần nhất",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() =>
                HistoryPollution(_controller.pollution.value?.results ?? []))
          ],
        ),
      ),
    );
  }

  void handleClickMenu(String value) {
    switch (value) {
      case 'Xóa':
        _controller.deleteUser();
        break;
      case 'Chỉnh sửa':
        Get.toNamed(Routes.EDIT_PROFILE_SCREEN,
                arguments: _controller.user.value)
            ?.then((value) {
          _controller.getUser();
        });
        break;
    }
  }
}
