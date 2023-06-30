import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/commons/constants.dart';
import '../../../../services/commons/helper.dart';
import '../../../../services/network/apis/pollution/pollution_api.dart';

class PollutionManageController extends GetxController {
  Rx<RefreshController> refreshController = RefreshController().obs;

  RxList<PollutionModel> pollutionList = RxList<PollutionModel>();
  Rx<TextEditingController> textEditController = TextEditingController().obs;
  Rx<bool> isShowFilter = false.obs;
  Rx<int> total = 0.obs;
  Rxn<int> filterSelected = Rxn<int>();
  List<int?> listFilterStatusValue = [null, 0, 1, 2];
  List<String> listFilterStatusTxt = [
    "Tất cả",
    "Đang chờ duyệt",
    "Đã duyệt",
    "Từ chối"
  ];

  UserModel? currentUser;

  RxList<String> filterTypes = ["land", "air", "sound", "water"].obs;
  List<String> listPollutionType = ["land", "air", "sound", "water"];

  String? searchText;
  int nextPage = 1;
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;

  Timer? _debounce;

  @override
  void onInit() {
    filterSelected.value = 0;
    showLoading();
    getAllPollution().then((value) => hideLoading());
    super.onInit();
  }

  Future<void> getAllPollution() async {
    currentUser = UserStore().getAuth()?.user;
    PollutionApi()
        .getAllPollution(
      page: nextPage,
      limit: _itemsPerPage,
      searchText: searchText,
      status: filterSelected.value,
      type: filterTypes.toList(),
      provinceIds:
          currentUser?.role == kRoleAdmin ? null : currentUser?.provinceManage,
    )
        .then((value) {
      pollutionList.addAll(value.results ?? []);
      total.value = value.totalResults ?? 0;
      if (canLoadMore) nextPage++;
      if ((value.results ?? []).length < _itemsPerPage) {
        canLoadMore = false;
      }
    }).onError((error, stackTrace) {
      showAlert(desc: "Không lấy được danh sách ô nhiễm");
    });
  }

  Future<void> deletePollution({required String id}) async {
    showLoading();
    PollutionApi().deletePollution(id: id).then((value) {
      hideLoading();
      pollutionList.removeWhere((element) => element.id == id);
      total.value -= 1;
      Fluttertoast.showToast(
          msg: value.message ?? "Xóa báo cáo ô nhiễm thành công");
    }).onError((error, stackTrace) {
      hideLoading();
    });
  }

  @override
  Future<void> refresh() async {
    canLoadMore = true;
    pollutionList.value = [];
    nextPage = 1;
    await getAllPollution();
  }

  void onSearch(String? search) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    showLoading();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      searchText = search;
      await refresh();
      hideLoading();
    });
  }

  void onRefresh() async {
    searchText = null;
    textEditController.value.clear();
    await refresh();
    refreshController.value.refreshCompleted();
  }

  void onLoading() async {
    await getAllPollution();
    refreshController.value.loadComplete();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
