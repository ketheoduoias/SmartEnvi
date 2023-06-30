import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/commons/helper.dart';
import '../../../../services/commons/size_config.dart';
import '../../../../services/network/apis/users/auth_api.dart';
import '../../../components/default_button.dart';
import '../../../components/keyboard.dart';
import '../../../../controllers/forgot_password_controller.dart';
import 'forgot_token_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              const Text(
                "Nhập địa chỉ email của bạn, chúng tôi sẽ gửi\n mã xác nhận đến email của bạn",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());

  ForgotPassForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => controller.onSave(newValue!),
            onChanged: (value) {
              controller.onChange(value);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return controller.onValidator(value!);
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Nhập email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.mail),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          DefaultButton(
            text: "Tiếp tục",
            press: () {
              if (_formKey.currentState!.validate()) {
                KeyboardUtil.hideKeyboard(context);
                showLoading();
                AuthApi().forgotPassword(controller.email.value).then((value) {
                  hideLoading();
                  Get.to(() => const ResetPassword());
                }, onError: (e) {
                  hideLoading();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
