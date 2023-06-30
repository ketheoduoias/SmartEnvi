import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/pollution_quality_model.dart';
import 'package:pollution_environment/model/pollution_type_model.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../components/default_button.dart';
import '../../../controllers/filter_screen_controller.dart';

class FilterMapScreen extends StatelessWidget {
  final FilterMapController _controller = Get.put(FilterMapController());

  FilterMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ lọc chi tiết'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(
          padding: const EdgeInsets.all(4),
          children: <Widget>[
            _buildProvinceSelection(),
            const SizedBox(
              height: 30,
            ),
            _buildDistrictSelection(),
            const SizedBox(
              height: 30,
            ),
            _buildWardSelection(),
            const SizedBox(
              height: 30,
            ),
            _buildTypeSelection(),
            const SizedBox(
              height: 30,
            ),
            _buildQualitySelection(),
            const SizedBox(
              height: 30,
            ),
            DefaultButton(
                text: 'Hoàn tất',
                press: () async {
                  await _controller.saveFilter();
                }),
          ],
        ),
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
          onFind: (String? filter) => _controller.getData(),
          items: _controller.provinces.toList(),
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

  Widget _buildDistrictSelection() {
    return Obx(() => DropdownSearch<DistrictModel>(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveDistrict(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          selectedItem: _controller.selectedDistrict.value,
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Quận/huyện",
            hintText: "Chọn quận/huyện",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          items: _controller.getDistricts(),
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
    return Obx(() => DropdownSearch<PollutionType>.multiSelection(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveType(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.key == selectedItem?.key,
          selectedItems: _controller.selectedType.toList(),
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Loại ô nhiễm",
            hintText: "Chọn loại ô nhiễm",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          onFind: (String? filter) => _controller.getPollutionTypes(),
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

  Widget _buildQualitySelection() {
    return Obx(() => DropdownSearch<PollutionQuality>.multiSelection(
          mode: Mode.MENU,
          onChanged: (item) => _controller.saveQuality(item),
          showSelectedItems: true,
          compareFn: (item, selectedItem) => item?.key == selectedItem?.key,
          selectedItems: _controller.selectedQuality.toList(),
          showSearchBox: true,
          dropdownSearchDecoration: const InputDecoration(
            labelText: "Mức độ ô nhiễm",
            hintText: "Chọn mức độ ô nhiễm",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          itemAsString: (item) => item?.name ?? "",
          onFind: (String? filter) => _controller.getPollutionQualities(),
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
}
