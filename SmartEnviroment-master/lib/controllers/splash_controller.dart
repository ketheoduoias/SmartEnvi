import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pollution_environment/model/token_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/routes/app_pages.dart';

import '../services/commons/constants.dart';
import '../services/commons/helper.dart';
import '../services/commons/location_service.dart';
import '../services/network/apis/users/auth_api.dart';

class SplashController extends GetxController {
  late Timer _timer;
  int _start = 3;
  var currentPage = 0.obs;
  final Box box = Hive.box(kHiveBox);
  @override
  void onInit() {
    super.onInit();
    LocationService().determinePosition();
    startTimer();
  }

  void setPage(int page) {
    currentPage.value = page;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 2);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          _timer.cancel();
          checkAccessPermission();
        } else {
          setPage(3 - _start);
          _start--;
        }
      },
    );
  }

  void checkAccessPermission() async {
    bool isRememberLogin = box.get(kRememberLogin, defaultValue: false);
    if (isRememberLogin) {
      AuthResponse? currentUser = UserStore().getAuth();
      String? refreshToken = currentUser?.tokens?.refresh?.token;
      if (refreshToken == null) {
        Get.offAllNamed(Routes.LOGIN_SCREEN);
      } else {
        showLoading();
        try {
          TokensResponse tokenResponse =
              await AuthApi().refreshToken(refreshToken);
          String? newAccessToken = tokenResponse.access?.token;
          String? newRefreshToken = tokenResponse.refresh?.token;

          hideLoading();
          if (newAccessToken != null && newRefreshToken != null) {
            currentUser?.tokens = tokenResponse;
            if (currentUser != null) {
              UserStore().saveAuth(currentUser);
            }
            Get.offAllNamed(Routes.HOME_SCREEN);
          } else {
            Get.offAllNamed(Routes.LOGIN_SCREEN);
          }
        } catch (e) {
          hideLoading();
          Get.offAllNamed(Routes.LOGIN_SCREEN);
        }
      }
    } else {
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    }
  }

  void stopTimer() {
    _timer.cancel();
  }
}
