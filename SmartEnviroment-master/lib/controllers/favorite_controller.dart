import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/address_model.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/address/address_api.dart';
import '../services/network/apis/waqi/waqi.dart';

class FavoriteController extends GetxController {
  RxList<ProvinceModel> provinces = RxList<ProvinceModel>();
  RxList<DistrictModel> districts = RxList<DistrictModel>();
  RxList<WardModel> wards = RxList<WardModel>();

  Rxn<ProvinceModel?> selectedProvince = Rxn<ProvinceModel?>();
  Rxn<DistrictModel?> selectedDistrict = Rxn<DistrictModel?>();
  Rxn<WardModel?> selectedWard = Rxn<WardModel?>();

  Rxn<WAQIIpResponse> aqi = Rxn<WAQIIpResponse>();
  RxnDouble lat = RxnDouble();
  RxnDouble lng = RxnDouble();

  @override
  void onInit() {
    super.onInit();
    showLoading();
    getData().then((value) => hideLoading());
  }

  Future<void> getData() async {
    var response = await AddressApi().getAllAddress();
    provinces.value = response.data ?? [];
  }

  void saveProvince(ProvinceModel? provinceModel) {
    selectedProvince.value = provinceModel;
    selectedDistrict.value = null;
    districts.value = getDistricts();

    selectedWard.value = null;
    wards.value = getWards();
  }

  void saveDistrict(DistrictModel? districtModel) {
    selectedDistrict.value = districtModel;
    selectedWard.value = null;
    wards.value = getWards();
  }

  void saveWard(WardModel? wardModel) {
    selectedWard.value = wardModel;
  }

  List<DistrictModel> getDistricts() {
    List<DistrictModel> districts = [];

    districts.addAll(selectedProvince.value?.districts ?? []);
    return districts;
  }

  List<WardModel> getWards() {
    List<WardModel> wards = [];

    wards.addAll(selectedDistrict.value?.wards ?? []);
    return wards;
  }

  void getAQI() async {
    try {
      List<Location> locations = await locationFromAddress(
          "${selectedWard.value?.name}, ${selectedDistrict.value?.name}, ${selectedProvince.value?.name}");

      if (locations.isEmpty) {
        locations = await locationFromAddress(
            "${selectedDistrict.value?.name}, ${selectedProvince.value?.name}");
      }
      if (locations.isEmpty) {
        locations =
            await locationFromAddress("${selectedProvince.value?.name}");
      }
      if (locations.isNotEmpty) {
        lat.value = locations.first.latitude;
        lng.value = locations.first.longitude;
        aqi.value = await WaqiAPI().getAQIByGPS(lat.value!, lng.value!);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
