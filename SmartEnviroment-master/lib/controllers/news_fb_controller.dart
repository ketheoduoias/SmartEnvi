import 'package:get/get.dart';
import 'package:pollution_environment/model/facebook_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/commons/helper.dart';
import '../services/network/apis/news/news_api.dart';

class NewsFBController extends GetxController {
  Rx<RefreshController> refreshController = RefreshController().obs;

  RxList<FBNews> newsList = RxList<FBNews>();

  int nextPage = 1;
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;

  @override
  void onInit() {
    getNews();
    super.onInit();
  }

  Future<void> getNews() async {
    NewsApi().getNewsFB(page: nextPage, limit: _itemsPerPage).then((value) {
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
