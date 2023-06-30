import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/commons/size_config.dart';
import 'components/body.dart';
import '../../../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
