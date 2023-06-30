import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/body.dart';
import '../../../../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  late final ProfileController _controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ sơ")),
      body: Obx(() => Body(user: _controller.user.value)),
    );
  }
}
