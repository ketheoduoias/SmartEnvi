import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';

import '../services/commons/helper.dart';
import '../services/commons/recommend.dart';
import '../services/network/apis/waqi/waqi.dart';

class DetailAQIController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int id = Get.arguments;
  Rxn<WAQIIpResponse> aqiModel = Rxn<WAQIIpResponse>();
  RxInt recommentType = 0.obs;
  RxString recommend = "".obs;

  late TabController tabController;

  @override
  void onInit() {
    getAqi();
    tabController = TabController(vsync: this, length: 2);
    super.onInit();
  }

  void getAqi() async {
    showLoading();
    aqiModel.value = await WaqiAPI().getAQIById(id);
    hideLoading();
    recommend.value =
        RecommendAQI.effectHealthy(aqiModel.value?.data?.aqi ?? 0);
  }

  void changeRecommed() {
    if (recommentType.value == 0) {
      // Sức khỏe
      recommend.value =
          RecommendAQI.effectHealthy(aqiModel.value?.data?.aqi ?? 0);
    } else if (recommentType.value == 1) {
      // Người bình thường
      recommend.value =
          RecommendAQI.actionNormalPeople(aqiModel.value?.data?.aqi ?? 0);
    } else {
      recommend.value =
          RecommendAQI.actionSensitivePeople(aqiModel.value?.data?.aqi ?? 0);
    }
  }
}
