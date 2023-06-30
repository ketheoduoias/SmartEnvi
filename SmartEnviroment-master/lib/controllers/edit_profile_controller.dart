import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/user_response.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/address/address_api.dart';
import '../services/network/apis/users/user_api.dart';

class EditProfileController extends GetxController {
  Rx<UserModel> userModel = (Get.arguments as UserModel).obs;
  Rxn<File> image = Rxn<File>();
  Rxn<String> password = Rxn<String>();
  Rxn<String> rePassword = Rxn<String>();
  Rxn<String> email = Rxn<String>();
  Rxn<String> name = Rxn<String>();
  Rxn<String> role = Rxn<String>();
  RxList<ProvinceModel> provinceManage = RxList<ProvinceModel>();
  RxList<ProvinceModel> allProvince = RxList<ProvinceModel>();
  Rxn<AuthResponse> currentUser = Rxn<AuthResponse>();
  @override
  void onInit() {
    email.value = userModel.value.email;
    name.value = userModel.value.name;
    role.value = userModel.value.role;
    getAuthResponse();
    getProvince();

    super.onInit();
  }

  void getAuthResponse() async {
    currentUser.value = UserStore().getAuth();
  }

  Future<void> updateUser() async {
    if (userModel.value.id != null) {
      List<String> provinces = [];
      provinceManage.toList().forEach((element) {
        if (element.id != null && element.id?.isNotEmpty == true) {
          provinces.add(element.id!);
        }
      });
      showLoading();
      UserAPI()
          .updateUser(
              id: userModel.value.id!,
              email: email.value,
              name: name.value,
              password: password.value,
              role: currentUser.value?.user?.role == role.value
                  ? null
                  : role.value,
              provinceManage: provinces,
              avatar: image.value)
          .then((value) async {
        currentUser.value?.user = value;
        if (currentUser.value != null) {
          await UserStore().saveAuth(currentUser.value!);
        }
        hideLoading();
        Get.back();
        Fluttertoast.showToast(msg: "Cập nhật hồ sơ thành công");
      }, onError: (e) {
        hideLoading();
        showAlert(desc: e.message);
      });
    }
  }

  void getProvince() async {
    var response = await AddressApi().getAllAddress();
    allProvince.value = response.data ?? [];
    List<ProvinceModel> provinces = [];

    for (var element in userModel.value.provinceManage) {
      if (element.isNotEmpty) {
        var province = response.data?.firstWhere((item) => element == item.id);
        if (province != null) provinces.add(province);
      }
    }
    provinceManage.value = provinces;
  }
}
