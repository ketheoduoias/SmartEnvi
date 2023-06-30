import 'package:get/get.dart';
import 'package:pollution_environment/model/news_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/news/news_api.dart';

class NewsWebController extends GetxController {
  Rx<RefreshController> refreshController = RefreshController().obs;

  RxList<NewsModel> newsList = RxList<NewsModel>();

  Rx<String> filterSelected = 'moitruong'.obs;
  List<String> listFilterStatusValue = [
    'moitruong',
    'racthai',
    'chatthai',
    'nuocthai',
    'onhiemnuoc',
    'onhiemkhongkhi'
  ];
  List<String> listFilterStatusTxt = [
    "Môi trường",
    "Rác thải",
    "Chất thải",
    "Nước thải",
    "Ô nhiễm nước",
    "Ô nhiễm không khí"
  ];

  int nextPage = 1;
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;

  Rx<bool> showBackToTopButton = false.obs;

  @override
  void onInit() {
    getNews();
    super.onInit();
  }

  Future<void> getNews() async {
    NewsApi()
        .getNews(
            page: nextPage, limit: _itemsPerPage, type: filterSelected.value)
        .then((value) {
      newsList.addAll(value.results ?? []);
      if (canLoadMore) nextPage++;
      if ((value.results ?? []).length < _itemsPerPage) {
        canLoadMore = false;
      }
    }).onError((error, stackTrace) {
      showAlert(desc: "Không lấy được danh sách tin tức");
    });
  }

  @override
  Future<void> refresh() async {
    canLoadMore = true;
    newsList.value = [];
    nextPage = 1;
    await getNews();
  }

  void onRefresh() async {
    await refresh();
    refreshController.value.refreshCompleted();
  }

  void onLoading() async {
    await getNews();
    refreshController.value.loadComplete();
  }
}
