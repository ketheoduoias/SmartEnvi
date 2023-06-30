import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/routes/app_pages.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn chưa có tài khoản? ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SIGNUP_SCREEN),
          child: Text(
            "Đăng ký ngay",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
