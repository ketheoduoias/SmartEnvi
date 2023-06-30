import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/commons/helper.dart';
import '../../../../services/network/apis/users/user_api.dart';

class UserManageController extends GetxController {
  Rx<RefreshController> refreshController = RefreshController().obs;

  RxList<UserModel> userList = RxList<UserModel>();
  Rx<TextEditingController> textEditController = TextEditingController().obs;

  Rx<int> total = 0.obs;

  String? searchText;
  int nextPage = 1;
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;

  Timer? _debounce;

  @override
  void onInit() {
    getAllUser();
    super.onInit();
  }

  Future<void> getAllUser() async {
    UserAPI()
        .getAllUser(
            page: nextPage, limit: _itemsPerPage, searchText: searchText)
        .then((value) {
      userList.addAll(value.results ?? []);
      total.value = value.totalResults ?? 0;
      if (canLoadMore) nextPage++;
      if ((value.results ?? []).length < _itemsPerPage) {
        canLoadMore = false;
      }
    }).onError((error, stackTrace) {
      showAlert(desc: "Không lấy được danh sách người dùng");
    });
  }

  @override
  Future<void> refresh() async {
    canLoadMore = true;
    userList.value = [];
    nextPage = 1;
    await getAllUser();
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
    await getAllUser();
    refreshController.value.loadComplete();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
