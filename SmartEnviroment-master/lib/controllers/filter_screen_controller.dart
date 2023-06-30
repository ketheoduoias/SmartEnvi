import 'package:get/get.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/pollution_quality_model.dart';
import 'package:pollution_environment/model/pollution_type_model.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/address/address_api.dart';
import '../services/network/apis/pollution/pollution_api.dart';
import 'filter_storage_controller.dart';

class FilterMapController extends GetxController {
  RxList<ProvinceModel> provinces =
      [ProvinceModel(id: "-1", name: "Tất cả")].obs;
  RxList<DistrictModel> districts =
      [DistrictModel(id: "-1", name: "Tất cả")].obs;
  RxList<WardModel> wards = [WardModel(id: "-1", name: "Tất cả")].obs;

  Rx<ProvinceModel?> selectedProvince =
      ProvinceModel(id: "-1", name: "Tất cả").obs;
  Rx<DistrictModel?> selectedDistrict =
      DistrictModel(id: "-1", name: "Tất cả").obs;
  Rx<WardModel?> selectedWard = WardModel(id: "-1", name: "Tất cả").obs;
  RxList<PollutionType> selectedType = RxList<PollutionType>();
  RxList<PollutionQuality> selectedQuality = RxList<PollutionQuality>();

  @override
  void onInit() {
    super.onInit();

    final FilterStorageController filterStorageController = Get.find();
    selectedProvince.value = filterStorageController.selectedProvince.value;
    selectedDistrict.value = filterStorageController.selectedDistrict.value;
    selectedWard.value = filterStorageController.selectedWard.value;
    selectedQuality.value = filterStorageController.selectedQuality.toList();
    selectedType.value = filterStorageController.selectedType.toList();
  }

  Future<List<PollutionType>> getPollutionTypes() async {
    var response = await PollutionApi().getPollutionTypes();
    final data = response;
    return data;
  }

  Future<List<PollutionQuality>> getPollutionQualities() async {
    var response = await PollutionApi().getPollutionQualities();
    final data = response;
    return data;
  }

  Future<List<ProvinceModel>> getData() async {
    var response = await AddressApi().getAllAddress();
    final data = response.data;
    return data ?? [];
  }

  void saveProvince(ProvinceModel? provinceModel) {
    selectedProvince.value = provinceModel;
    selectedDistrict.value = DistrictModel(id: "-1", name: "Tất cả");
    districts.value = getDistricts();

    selectedWard.value = WardModel(id: "-1", name: "Tất cả");
    wards.value = getWards();
  }

  void saveDistrict(DistrictModel? districtModel) {
    selectedDistrict.value = districtModel;
    selectedWard.value = WardModel(id: "-1", name: "Tất cả");
    wards.value = getWards();
  }

  void saveWard(WardModel? wardModel) {
    selectedWard.value = wardModel;
  }

  void saveType(List<PollutionType> pollutionType) {
    selectedType.value = pollutionType;
  }

  void saveQuality(List<PollutionQuality> pollutionQulities) {
    selectedQuality.value = pollutionQulities;
  }

  List<DistrictModel> getDistricts() {
    List<DistrictModel> districts = [DistrictModel(id: "-1", name: "Tất cả")];

    districts.addAll(selectedProvince.value?.districts ?? []);
    return districts;
  }

  List<WardModel> getWards() {
    List<WardModel> wards = [WardModel(id: "-1", name: "Tất cả")];

    wards.addAll(selectedDistrict.value?.wards ?? []);
    return wards;
  }

  Future<void> saveFilter() async {
    final FilterStorageController filterStorageController = Get.find();
    filterStorageController.selectedDistrict.value = selectedDistrict.value;
    filterStorageController.selectedProvince.value = selectedProvince.value;
    filterStorageController.selectedWard.value = selectedWard.value;
    filterStorageController.selectedQuality.value = selectedQuality.toList();
    filterStorageController.selectedType.value = selectedType.toList();

    String? provinceId = selectedProvince.value?.id;
    String? districtId = selectedDistrict.value?.id;
    if (provinceId != null && provinceId != "-1") {
      showLoading();
      AddressApi().getAddressById(provinceId).then((provinceDetail) {
        List<List<double>> polygon =
            provinceDetail.coordinates?.first.first ?? [];
        List<double> bbox = provinceDetail.bbox ?? [];
        if (districtId != null && districtId != "-1") {
          var districtDetail = provinceDetail.districts
              ?.firstWhere((element) => element.id == districtId);
          if (districtDetail != null) {
            polygon = districtDetail.coordinates?.first.first ?? [];
            bbox = districtDetail.bbox ?? [];
          }
        }
        filterStorageController.polygon.value = polygon;
        filterStorageController.bbox.value = bbox;
        hideLoading();
        Get.back();
      }).catchError((error) {
        filterStorageController.polygon.value = [];
        filterStorageController.bbox.value = [];
        hideLoading();
        Get.back();
      });
    } else {
      filterStorageController.polygon.clear();
      filterStorageController.bbox.clear();
      Get.back();
    }
  }
}
