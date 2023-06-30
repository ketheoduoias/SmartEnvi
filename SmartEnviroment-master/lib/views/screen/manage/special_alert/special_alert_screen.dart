import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pollution_environment/model/alert_model.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/commons/helper.dart';
import '../../../../services/network/apis/alert/alert_api.dart';
import '../../alert/alert_detail_screen.dart';
import 'create_alert_screen.dart';

class SpecialAlertScreen extends StatefulWidget {
  const SpecialAlertScreen({Key? key}) : super(key: key);

  @override
  State<SpecialAlertScreen> createState() {
    return SpecialAlertState();
  }
}

class SpecialAlertState extends State<SpecialAlertScreen> {
  UserModel? currentUser;
  List<Alert> _alerts = [];

  RefreshController refreshController = RefreshController();
  int nextPage = 1;
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    currentUser = UserStore().getAuth()?.user;
    showLoading();
    AlertApi().getAlerts().then((value) {
      setState(() {
        _alerts = value.results ?? [];
        if (canLoadMore) nextPage++;
        if ((value.results ?? []).length < _itemsPerPage) {
          canLoadMore = false;
        }
      });
      hideLoading();
    });
    setState(() {});
  }

  Future<void> getAlert() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      AlertApi()
          .getAlerts(
        page: nextPage,
        limit: _itemsPerPage,
      )
          .then(
        (value) {
          _alerts.addAll(value.results ?? []);
          if (canLoadMore) nextPage++;
          if ((value.results ?? []).length < _itemsPerPage) {
            canLoadMore = false;
          }
          setState(() {});
        },
      );
    });
  }

  Future<void> _refresh() async {
    canLoadMore = true;
    _alerts = [];
    nextPage = 1;
    await getAlert();
  }

  void _onRefresh() async {
    await _refresh();
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await getAlert();
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateAlertScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const ClassicHeader(
          idleText: "Kéo để làm mới",
          refreshingText: "Đang tải...",
          releaseText: "Kéo để làm mới",
          completeText: "Lấy dữ liệu thành công",
          refreshStyle: RefreshStyle.Follow,
        ),
        footer: const ClassicFooter(
          idleText: "Kéo để tải thêm",
          loadingText: "Đang tải...",
          failedText: "Tải thêm dữ liệu thất bại",
          noDataText: "Không có dữ liệu mới",
          canLoadingText: "Kéo để tải thêm",
        ),
        controller: refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          primary: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_alerts[index].title ?? ""),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _alerts[index].content ?? "",
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      timeAgoSinceDate(dateStr: _alerts[index].createdAt!),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(color: Colors.grey),
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              leading: SizedBox(
                width: 60,
                height: 60,
                child: _alerts[index].images?.isNotEmpty == true
                    ? CachedNetworkImage(
                        imageUrl: _alerts[index].images?.first ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.fill,
                        errorWidget: (ctx, str, _) {
                          return LineIcon(LineIcons.bullhorn,
                              size: 30, color: Colors.red);
                        },
                        progressIndicatorBuilder: (ctx, str, _) =>
                            const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : LineIcon(
                        LineIcons.bullhorn,
                        size: 30,
                        color: Colors.red,
                      ),
              ),
              onTap: () {
                Get.to(() => AlertDetailScreen(
                      alert: _alerts[index],
                    ));
              },
            );
          },
          itemCount: _alerts.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              indent: 10,
              endIndent: 10,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
