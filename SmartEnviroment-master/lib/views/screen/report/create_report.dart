import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/pollution_quality_model.dart';
import 'package:pollution_environment/model/pollution_type_model.dart';

import '../../../services/commons/helper.dart';
import '../../components/default_button.dart';
import '../../../controllers/create_report_controller.dart';

class CreateReport extends StatelessWidget {
  late final CreateReportController _controller =
      Get.put(CreateReportController());
  final _formKey = GlobalKey<FormState>();

  CreateReport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Báo cáo địa điểm ô nhiễm',
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _buildProvinceSelection(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildDistrictSelection(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildWardSelection(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildSpecialAddressInput(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildTypeSelection(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildQualitySelection(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildDescriptionInput(),
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
                  height: 10,
                ),
                const SizedBox(
                  height: 30,
                ),
                DefaultButton(
                  text: 'Hoàn thành',
                  press: () => createReport(context),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildImageList(BuildContext context) {
    return Obx(() => _controller.images.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(5.0),
                height: 150.0,
                child: ListView.builder(
                    itemCount: _controller.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => _buildItemImage(index)),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
            ],
          )
        : const SizedBox());
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
              _controller.images[index],
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                _controller.images.removeAt(index);
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

  Widget _buildProvinceSelection() {
    return Obx(() => DropdownSearch<ProvinceModel>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveProvince(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: _controller.selectedProvince.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Tỉnh/Thành phố",
            hintText: "Chọn tỉnh/thành phố",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          onFind: (String? filter) => _controller.getDataProvince(),
          maxHeight: 300,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (item) {
            if (item == null) {
              return "Trường này là bắt buộc";
            } else {
              return null;
            }
          },
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

  Widget _buildDistrictSelection() {
    return Obx(() => DropdownSearch<DistrictModel>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveDistrict(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: _controller.selectedDistrict.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Quận/Huyện",
            hintText: "Chọn quận/huyện",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          items: _controller.getDistricts(),
          maxHeight: 300,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (item) {
            if (item == null) {
              return "Trường này là bắt buộc";
            } else {
              return null;
            }
          },
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

  Widget _buildWardSelection() {
    return Obx(() => DropdownSearch<WardModel>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveWard(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: _controller.selectedWard.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Phường/Xã",
            hintText: "Chọn phường/xã",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          items: _controller.getWards(),
          maxHeight: 300,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (item) {
            if (item == null) {
              return "Trường này là bắt buộc";
            } else {
              return null;
            }
          },
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

  Widget _buildTypeSelection() {
    return Obx(() => DropdownSearch<PollutionType>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveType(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.key == selectedItem?.key,
          selectedItem: _controller.selectedType.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Loại ô nhiễm",
            hintText: "Chọn loại ô nhiễm",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          onFind: (String? filter) => _controller.getPollutionTypes(),
          maxHeight: 300,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (item) {
            if (item == null) {
              return "Trường này là bắt buộc";
            } else {
              return null;
            }
          },
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

  Widget _buildQualitySelection() {
    return Obx(() => DropdownSearch<PollutionQuality>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveQuality(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.key == selectedItem?.key,
          selectedItem: _controller.selectedQuality.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Mức độ ô nhiễm",
            hintText: "Chọn mức độ",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          onFind: (String? filter) => _controller.getPollutionQualities(),
          maxHeight: 300,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          validator: (item) {
            if (item == null) {
              return "Trường này là bắt buộc";
            } else {
              return null;
            }
          },
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

  Widget _buildSpecialAddressInput() {
    return TextFormField(
      keyboardType: TextInputType.streetAddress,
      onSaved: (newValue) => _controller.saveSpecialAddress(newValue),
      onChanged: (value) {
        _controller.saveSpecialAddress(value);
      },
      minLines: 1,
      maxLines: 5,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (item) {
        if (item == null || item.isEmpty) {
          return "Trường này là bắt buộc";
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: "Địa chỉ chi tiết",
        hintText: "Nhập địa chỉ chi tiết",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => _controller.saveDescription(newValue),
      onChanged: (value) {
        _controller.saveDescription(value);
      },
      minLines: 2,
      maxLines: 5,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (item) {
        if (item == null || item.isEmpty) {
          return "Trường này là bắt buộc";
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        labelText: "Mô tả",
        hintText: "Nhập mô tả thông tin ô nhiễm",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
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
          _controller.images.add(File(image.path));
        }
      } else {
        resultList = await _picker.pickMultiImage() ?? [];
        _controller.images.addAll(resultList.map((e) => File(e.path)).toList());
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> createReport(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _controller.createReport((error) {
        showAlert(desc: error);
      });
    }
  }
}
