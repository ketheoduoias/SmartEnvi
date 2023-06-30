import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/notification_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../services/commons/helper.dart';
import '../../../services/network/apis/notification/notification_api.dart';
import '../../components/empty_view.dart';
import '../detail_pollution/detail_pollution_screen.dart';

class NotificationPollutionScreen extends StatefulWidget {
  const NotificationPollutionScreen({Key? key}) : super(key: key);

  @override
  _NotificationPollutionState createState() => _NotificationPollutionState();
}

class _NotificationPollutionState extends State<NotificationPollutionScreen>
    with AutomaticKeepAliveClientMixin<NotificationPollutionScreen> {
  List<NotificationModel> list = [];
  final RefreshController _refreshController = RefreshController();
  static const int _itemsPerPage = 10;
  bool canLoadMore = true;
  int nextPage = 1;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SmartRefresher(
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
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.separated(
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              // primary: true,
              itemBuilder: (c, i) {
                if (list.isEmpty) {
                  return const EmptyView();
                } else {
                  return buildRow(c, i);
                }
              },
              itemCount: list.isEmpty ? 1 : list.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  indent: 10,
                  endIndent: 10,
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10 + MediaQuery.of(context).padding.bottom,
          right: 15,
          child: Ink(
            child: InkWell(
              radius: 15,
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                _clearAll();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                ),
                child: const Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> getData() async {
    var data = await NotificationApi().getNotifications(page: nextPage);
    setState(() {
      list.addAll(data.results ?? []);
    });
    if (canLoadMore) nextPage++;
    if ((data.results ?? []).length < _itemsPerPage) {
      canLoadMore = false;
    }
  }

  Future<void> refresh() async {
    canLoadMore = true;
    list.clear();
    nextPage = 1;
    await getData();
  }

  void _onRefresh() async {
    await refresh();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await getData();
    _refreshController.loadComplete();
  }

  void _clearAll() async {
    showAlert(
        desc: "Bạn có chắc chắn muốn xóa tất cả thông báo không ?",
        onConfirm: () {
          Get.back();
          showLoading();
          NotificationApi().deleteAllNotification().then((value) {
            setState(() {
              list = [];
            });
            hideLoading();
            Fluttertoast.showToast(
                msg: value.message ?? "Xóa tất cả thông báo thành công");
          });
        });
  }

  void _deleteById(String id) {
    setState(() {
      list.removeWhere((element) => element.id == id);
    });
    NotificationApi().deleteNotificationById(id: id);
  }

  @override
  void initState() {
    super.initState();
    list = [];
    showLoading();
    getData().then((value) => hideLoading());
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            _deleteById(list[index].id!);
          }),
          children: [
            SlidableAction(
              onPressed: (ct) {
                _deleteById(list[index].id!);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            // Vào màn xem chi tiết
            Get.to(() => DetailPollutionScreen(),
                arguments: list[index].pollution?.id);
          },
          leading: Image.asset(
            getAssetPollution(list[index].pollution?.type ?? ''),
            width: 50,
            height: 50,
          ),
          title: Text(
            list[index].pollution?.specialAddress ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${list[index].pollution?.wardName}, ${list[index].pollution?.districtName}, ${list[index].pollution?.provinceName}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  timeAgoSinceDate(dateStr: list[index].createdAt!),
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
        ),
      ),
    );
  }
}
