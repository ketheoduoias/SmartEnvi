import 'package:get/state_manager.dart';

import '../services/commons/constants.dart';

class ForgotPasswordController extends GetxController {
  RxString email = "".obs;

  void onSave(String value) {
    email.value = value;
  }

  void onChange(String value) {
    email.value = value;
  }

  String? onValidator(String value) {
    if (value.isEmpty) {
      return kEmailNullError;
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      return kInvalidEmailError;
    }
    return null;
  }
}
