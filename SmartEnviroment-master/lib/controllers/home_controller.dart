import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pollution_environment/model/favorite_model.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/commons/constants.dart';
import '../services/commons/helper.dart';
import '../services/network/apis/waqi/waqi.dart';

class HomeController extends GetxController {
  Rx<UserModel>? currentUser = UserStore().getAuth()?.user?.obs;
  Rxn<WAQIIpResponse> currentAQI = Rxn<WAQIIpResponse>();
  Rx<RefreshController> refreshController = RefreshController().obs;
  RxMap<String, WAQIIpResponse> favoriteAqis = RxMap<String, WAQIIpResponse>();
  @override
  void onInit() {
    showLoading();
    Future.wait([
      getCurrentAQI(),
      getFavorite(),
    ]).then((value) {
      hideLoading();
    }, onError: (e) {
      hideLoading();
    });
    super.onInit();
  }

  Future<void> getCurrentAQI() async {
    currentAQI.value = await WaqiAPI().getAQIByIP();
  }

  Future<void> getFavorite() async {
    await Hive.openBox<Favorite>(kFavorite);
    Box box = Hive.box<Favorite>(kFavorite);
    List<Favorite> favorites = box.values.cast<Favorite>().toList();
    for (var fav in favorites) {
      WaqiAPI().getAQIByGPS(fav.lat, fav.lng).then((value) => favoriteAqis
          .addAll({"${fav.ward}, ${fav.district}, ${fav.province}": value}));
    }
  }

  void removeFavorite(int index) async {
    await Hive.openBox<Favorite>(kFavorite);
    Box box = Hive.box<Favorite>(kFavorite);
    List<Favorite> favorites = box.values.cast<Favorite>().toList();
    var idx = favorites.indexWhere((fav) =>
        favoriteAqis.keys.toList()[index] ==
        "${fav.ward}, ${fav.district}, ${fav.province}");
    box.deleteAt(idx);
    favoriteAqis.remove(favoriteAqis.keys.toList()[index]);
    favoriteAqis.refresh();
  }

  void onRefreshData() async {
    Future.wait([
      getCurrentAQI(),
      getFavorite(),
    ]).then((value) {
      refreshController.value.refreshCompleted();
    }, onError: (e) {
      refreshController.value.refreshCompleted();
    });
  }
}
