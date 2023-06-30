import 'package:get/get.dart';
import 'package:pollution_environment/model/area_forest_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/network/apis/airvisual/airvisual.dart';

class IQAirController extends GetxController {
  Rx<RefreshController> refreshController = RefreshController().obs;

  RxList<AreaForestModel> areaForests = RxList<AreaForestModel>();
  RxList<IQAirRankVN> iqAirRankVN = RxList<IQAirRankVN>();

  @override
  void onInit() {
    getAreaForest();
    getRankVN();
    super.onInit();
  }

  Future<void> getAreaForest() async {
    AreaForestAPI().getAreaForest().then((value) {
      value.sort((a, b) {
        var intA = int.tryParse(a.rank ?? "0") ?? 0;
        var intB = int.tryParse(b.rank ?? "0") ?? 0;
        return intA - intB;
      });
      areaForests.addAll(value);
    });
  }

  Future<void> getRankVN() async {
    AreaForestAPI().getRankVN().then((value) {
      iqAirRankVN.addAll(value);
    });
  }

  @override
  Future<void> refresh() async {
    areaForests.value = [];
    iqAirRankVN.value = [];
    getAreaForest();
    getRankVN();
  }

  void onRefresh() async {
    await refresh();
    refreshController.value.refreshCompleted();
  }
}
