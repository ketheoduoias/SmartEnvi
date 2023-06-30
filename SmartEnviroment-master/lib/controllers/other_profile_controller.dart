import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/user_response.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/pollution/pollution_api.dart';
import '../services/network/apis/users/user_api.dart';

class OtherProfileController extends GetxController {
  String? userId = Get.arguments;
  Rxn<UserModel> user = Rxn<UserModel>();
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  Rxn<PollutionsResponse> pollution = Rxn<PollutionsResponse>();
  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
    showLoading();
    Future.wait([
      getUser(),
      getPollution(),
    ]).then((value) => hideLoading());
  }

  Future<void> getPollution() async {
    if (userId != null) {
      PollutionApi()
          .getPollutionByUser(userId: userId!)
          .then((value) => pollution.value = value);
    }
  }

  void getCurrentUser() async {
    currentUser.value = UserStore().getAuth()?.user;
  }

  Future<void> getUser() async {
    if (userId != null) {
      user.value = await UserAPI().getUserById(userId!);
    }
  }

  void deleteUser() async {
    if (userId != null) {
      showLoading();
      UserAPI().deleteUser(id: userId!).then((value) {
        hideLoading();
        Fluttertoast.showToast(
            msg: value.message ?? "Xóa người dùng thành công");

        Get.back();
      }).onError((error, stackTrace) {
        hideLoading();
      });
    }
  }
}
