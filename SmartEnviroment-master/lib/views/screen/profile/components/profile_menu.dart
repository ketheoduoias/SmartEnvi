import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/routes/app_pages.dart';

import '../../../../services/network/apis/users/auth_api.dart';
import '../../../../controllers/profile_controller.dart';
import 'card_menu.dart';

class ProfileMenu extends StatelessWidget {
  ProfileMenu({Key? key, this.user}) : super(key: key);

  final UserModel? user;

  late final ProfileController _profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            child: Text(
              "CÀI ĐẶT",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            width: double.infinity,
          ),
        ),
        Obx(
          () => CardMenu(
            text: "Giao diện",
            leftIcon: const Icon(Icons.dark_mode_rounded),
            right: DropdownButton<String>(
                // isExpanded: true,
                underline: const SizedBox(),
                alignment: AlignmentDirectional.centerEnd,
                value: _profileController.themeMode.value,
                items: const [
                  DropdownMenuItem(
                    child: Text("Sáng"),
                    value: "light",
                  ),
                  DropdownMenuItem(
                    child: Text("Tối"),
                    value: "dark",
                  ),
                  DropdownMenuItem(
                    child: Text("Hệ thống"),
                    value: "system",
                  ),
                ],
                onChanged: (value) {
                  _profileController.changeThemeMode(value);
                }),
          ),
        ),
        CardMenu(
          text: "Thông báo",
          leftIcon: const Icon(Icons.notifications_rounded),
          right: Switch(
              value: user?.isNotificationReceived ?? false,
              onChanged: (value) {
                _profileController.updateNotificationReceived(value);
                user?.isNotificationReceived = value;
              }),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            child: Text(
              "TÀI KHOẢN",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            width: double.infinity,
          ),
        ),
        CardMenu(
          text: "Chỉnh sửa",
          leftIcon: const Icon(Icons.edit_rounded),
          right: const Icon(Icons.chevron_right_sharp),
          onTap: () {
            Get.toNamed(Routes.EDIT_PROFILE_SCREEN, arguments: user)
                ?.then((value) {
              _profileController.getUser();
            });
          },
        ),
        CardMenu(
          text: "Đăng xuất",
          leftIcon: const Icon(Icons.logout_rounded),
          right: const Icon(Icons.chevron_right_sharp),
          onTap: () {
            AuthApi().logout();
            AuthApi().clearUserData();
            Get.offAllNamed(Routes.LOGIN_SCREEN);
          },
        ),
      ],
    );
  }
}
