import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../services/network/apis/pollution/pollution_api.dart';

class DashboardControler extends GetxController {
  Rx<int> currentChart = 0.obs;

  Rx<String> appName = "".obs;
  Rx<String> version = "".obs;
  Rx<String> buildNumber = "".obs;

  Rx<double> airCnt = (0.0).obs;
  Rx<double> soundCnt = (0.0).obs;
  Rx<double> landCnt = (0.0).obs;
  Rx<double> waterCnt = (0.0).obs;
  RxList<int> weekAirData = [0, 0, 0, 0, 0, 0, 0, 0].obs;
  RxList<int> weekLandData = [0, 0, 0, 0, 0, 0, 0, 0].obs;
  RxList<int> weekSoundData = [0, 0, 0, 0, 0, 0, 0, 0].obs;
  RxList<int> weekWaterData = [0, 0, 0, 0, 0, 0, 0, 0].obs;

  @override
  void onInit() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName.value = packageInfo.appName;
      version.value = packageInfo.version;
      buildNumber.value = packageInfo.buildNumber;
    });
    getStats();
    super.onInit();
  }

  void getStats() {
    PollutionApi().getPollutionStats().then((value) {
      airCnt.value = 100.0 * value.air / value.total;
      soundCnt.value = 100.0 * value.sound / value.total;
      landCnt.value = 100.0 * value.land / value.total;
      waterCnt.value = 100.0 - airCnt.value - soundCnt.value - landCnt.value;

      value.weekData?.forEach((element) {
        String? createdAt = element.createdAt;
        if (createdAt != null) {
          DateTime parseDate =
              DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(createdAt);

          var date = parseDate.weekday;
          if (element.type == "air") weekAirData[date] += 1;
          if (element.type == "land") weekLandData[date] += 1;
          if (element.type == "sound") weekSoundData[date] += 1;
          if (element.type == "water") weekWaterData[date] += 1;
        }
      });
    });
  }
}
