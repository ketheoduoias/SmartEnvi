import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pollution_environment/model/user_response.dart';

import '../services/commons/constants.dart';
import '../services/commons/helper.dart';
import '../services/commons/theme.dart';
import '../services/network/apis/users/user_api.dart';

class ProfileController extends GetxController {
  late String userId;
  Box box = Hive.box(kHiveBox);
  Rxn<UserModel> user = Rxn<UserModel>();
  Rx<String?> themeMode = "system".obs;
  @override
  void onInit() {
    themeMode.value = box.get(kThemeMode, defaultValue: "system");
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() async {
    AuthResponse? auth = UserStore().getAuth();
    user.value = auth?.user;
    userId = auth?.user?.id ?? "";
    getUser();
  }

  void getUser() async {
    showLoading();
    user.value = await UserAPI().getUserById(userId);
    hideLoading();
  }

  void updateNotificationReceived(bool isReceived) async {
    user.value = await UserAPI()
        .updateNotificationReceived(id: userId, isReceived: isReceived);
  }

  void changeThemeMode(value) {
    themeMode.value = value;
    Get.changeThemeMode(getThemeMode(value));
    box.put(kThemeMode, value ?? "system");
  }
}
