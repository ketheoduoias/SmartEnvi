import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/user_response.dart';

import '../../../../services/commons/constants.dart';
import '../../../../services/commons/helper.dart';
import '../../../../services/network/apis/address/address_api.dart';
import '../../../../services/network/apis/alert/alert_api.dart';
import '../../../components/default_button.dart';

class CreateAlertScreen extends StatefulWidget {
  const CreateAlertScreen({Key? key}) : super(key: key);

  @override
  State<CreateAlertScreen> createState() {
    return CreateAlertState();
  }
}

class CreateAlertState extends State<CreateAlertScreen> {
  String? title;
  String? content;
  List<File> images = [];
  List<ProvinceModel> provinceIds = [];
  List<ProvinceModel> provinces = [];

  UserModel? currentUser;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    currentUser = UserStore().getAuth()?.user;
    var response = await AddressApi().getAllAddress();
    final data = response.data;
    if (currentUser?.role == kRoleAdmin) {
      provinces = data ?? [];
    } else {
      provinces = [];
      data?.forEach((element) {
        if ((currentUser?.provinceManage ?? []).contains(element.id)) {
          provinces.add(element);
        }
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo thông báo"),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildFormTitle(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildFormContent(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildProvinceSelection(),
                  const SizedBox(
                    height: 20,
                  ),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 2,
                    dashPattern: const [5, 5],
                    radius: const Radius.circular(20),
                    padding: const EdgeInsets.all(6),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildImageList(context),
                          TextButton(
                              onPressed: () => loadAssets(isCamera: true),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.file_upload_rounded,
                                    size: 50,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const Text(
                                    "Tải ảnh lên",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                          TextButton(
                              onPressed: () => loadAssets(isCamera: false),
                              child: const Text(
                                "Chọn ảnh từ thư viện",
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DefaultButton(
                    text: 'Hoàn thành',
                    press: () => createReport(),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProvinceSelection() {
    return DropdownSearch<ProvinceModel>.multiSelection(
      mode: Mode.MENU,
      onChanged: (item) {
        provinceIds = item;
        setState(() {});
      },
      showSelectedItems: true,
      compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
      selectedItems: provinceIds,
      showSearchBox: true,
      dropdownSearchDecoration: const InputDecoration(
        labelText: "Phạm vi",
        hintText: "Chọn tỉnh/thành phố nhận thông báo",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      itemAsString: (item) => item?.name ?? "",
      items: provinces,
      maxHeight: 300,
      searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: const Icon(Icons.search),
              hintText: "Nhập để tìm kiếm",
              hintStyle: const TextStyle(color: Colors.grey))),
      popupShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _buildImageList(BuildContext context) {
    return images.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                height: 150.0,
                child: ListView.builder(
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => _buildItemImage(index)),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildItemImage(int index) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(1),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.file(
              images[index],
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                images.removeAt(index);
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadAssets({required bool isCamera}) async {
    List<XFile> resultList = <XFile>[];
    final ImagePicker _picker = ImagePicker();
    try {
      if (isCamera) {
        XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          images.add(File(image.path));
          setState(() {});
        }
      } else {
        resultList = await _picker.pickMultiImage() ?? [];
        images.addAll(resultList.map((e) => File(e.path)).toList());
        setState(() {});
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Widget _buildFormTitle() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (newValue) {
        setState(() {
          title = newValue;
        });
      },
      onChanged: (value) {
        setState(() {
          title = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Trường này là bắt buộc";
        }
        return null;
      },
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: "Tiêu đề",
        hintText: "Nhập tiêu đề",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildFormContent() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (newValue) {
        setState(() {
          content = newValue;
        });
      },
      onChanged: (value) {
        setState(() {
          content = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Trường này là bắt buộc";
        }
        return null;
      },
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: "Nội dung",
        hintText: "Nhập nội dung thông báo",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Future<void> createReport() async {
    if (_formKey.currentState!.validate()) {
      AlertApi()
          .createAlert(
              title: title!,
              content: content!,
              provinceIds: provinceIds.map((e) => e.id ?? "").toList(),
              files: images.toList(),
              onSendProgress: (sent, total) {
                showLoading(
                    text: "Đang tải lên ...", progress: 1.0 * sent / total);
              })
          .then(
        (value) {
          hideLoading();
          Fluttertoast.showToast(msg: "Tạo cảnh báo thành công");
          Get.back();
        },
        onError: (e) {
          hideLoading();
        },
      );
    }
  }
}
