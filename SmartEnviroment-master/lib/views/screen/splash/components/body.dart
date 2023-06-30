import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/commons/constants.dart';
import '../../../components/default_button.dart';
// This is the best practice
import '../components/splash_content.dart';
import '../../../../controllers/splash_controller.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);
  final List<Map<String, String>> splashData = [
    {
      "text": "Chào mừng bạn cùng chúng tôi,\n Chung tay bảo vệ môi trường!",
      "image": "assets/images/image_splash1.png"
    },
    {
      "text":
          "Ô nhiễm là bắt nguồn từ việc đưa\n các chất gây ô nhiễm vào môi trường tự nhiên. ",
      "image": "assets/images/image_splash2.png"
    },
    {
      "text":
          "Ô nhiễm không khí giết chết khoảng\n 7 triệu người trên toàn thế giới mỗi năm.",
      "image": "assets/images/image_splash3.png"
    },
  ];
  final SplashController conn = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  conn.setPage(value);
                  conn.stopTimer();
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => Obx(() => SplashContent(
                      image: splashData[conn.currentPage.value]["image"],
                      text: splashData[conn.currentPage.value]['text'],
                    )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) =>
                            Obx(() => buildDot(context: context, index: index)),
                      ),
                    ),
                    const Spacer(flex: 3),
                    DefaultButton(
                      text: "Tiếp tục",
                      press: () {
                        conn.stopTimer();
                        conn.checkAccessPermission();
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required BuildContext context, int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: conn.currentPage.value == index ? 20 : 6,
      decoration: BoxDecoration(
        color: conn.currentPage.value == index
            ? Theme.of(context).primaryColor
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
