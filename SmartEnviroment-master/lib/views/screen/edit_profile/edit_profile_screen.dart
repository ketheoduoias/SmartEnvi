import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pollution_environment/model/address_model.dart';

import '../../../services/commons/constants.dart';
import '../../components/keyboard.dart';
import '../../../controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final EditProfileController _controller = Get.put(EditProfileController());

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thay đổi thông tin"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        Obx(() => CircleAvatar(
                              backgroundImage: (_controller.image.value == null
                                  ? (_controller.userModel.value.avatar == null
                                      ? const AssetImage(
                                          "assets/images/profile_image.png")
                                      : NetworkImage(
                                          _controller.userModel.value.avatar!,
                                        ))
                                  : FileImage(_controller
                                      .image.value!)) as ImageProvider<Object>?,
                            )),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () {
                                  loadAssets();
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildNameFormField(),
                  const SizedBox(height: 20),
                  buildEmailFormField(),
                  const SizedBox(height: 20),
                  Obx(() => _controller.currentUser.value?.user?.role == "admin"
                      ? Column(children: [
                          buildRole(),
                          const SizedBox(
                            height: 20,
                          ),
                        ])
                      : Container()),
                  Obx(() =>
                      _controller.currentUser.value?.user?.role == "admin" &&
                              _controller.role.value == "mod"
                          ? Column(
                              children: [
                                _buildProvinceSelection(),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : Container()),
                  buildPasswordFormField(),
                  const SizedBox(height: 20),
                  buildRePasswordFormField(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey)),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Huỷ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              KeyboardUtil.hideKeyboard(context);
                              _formKey.currentState!.save();
                              _controller.updateUser();
                            }
                          },
                          child: const Text(
                            "Cập nhật",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget buildNameFormField() {
    return Obx(() => TextFormField(
          controller: nameController,
          keyboardType: TextInputType.text,
          onSaved: (newValue) {
            if (newValue != null && newValue.isNotEmpty) {
              _controller.name.value = newValue;
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(
            labelText: "Họ tên",
            hintText: _controller.userModel.value.name,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ));
  }

  Widget buildEmailFormField() {
    return Obx(() => TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (newValue) {
            if (newValue != null && newValue.isNotEmpty) {
              _controller.email.value = newValue;
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return null;
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              return kInvalidEmailError;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: "Email",
            hintText: _controller.userModel.value.email,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ));
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      onChanged: (newValue) {
        _controller.password.value = newValue;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return null;
        } else if (value.length < 6) {
          return kShortPassError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Nhập mật khẩu mới",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildRePasswordFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      onChanged: (newValue) {
        _controller.rePassword.value = newValue;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return null;
        } else if (value != _controller.password.value) {
          return kMatchPassError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Nhập lại mật khẩu mới",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildRole() {
    return DropdownSearch<String>(
      mode: Mode.MENU,
      onChanged: (item) => _controller.role.value = item,
      showSelectedItems: true,
      compareFn: (item, selectedItem) => item == selectedItem,
      selectedItem: _controller.role.value,
      showSearchBox: false,
      dropdownSearchDecoration: const InputDecoration(
        labelText: "Chức vụ",
        hintText: "Chọn chức vụ",
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
      ),
      itemAsString: (item) {
        if (item == "mod") {
          return "Người kiểm duyệt";
        } else if (item == "admin") {
          return "Quản trị viên";
        } else {
          return "Thành viên";
        }
      },
      items: const ["user", "mod", "admin"],
      // maxHeight: 300,
      popupShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _buildProvinceSelection() {
    return Obx(() => DropdownSearch<ProvinceModel>.multiSelection(
          mode: Mode.MENU,
          onChanged: (item) => _controller.provinceManage.value = item,
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItems: _controller.provinceManage.toList(),
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Tỉnh/Thành phố kiểm duyệt",
            hintText: "Chọn tỉnh/thành phố kiểm duyệt",
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          ),
          itemAsString: (item) => item?.name ?? "",
          items: _controller.allProvince.toList(),
          maxHeight: 300,
          searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Nhập để tìm kiếm",
                  hintStyle: const TextStyle(color: Colors.grey))),
          popupShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
  }

  Future<void> loadAssets() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) _controller.image.value = File(image.path);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
