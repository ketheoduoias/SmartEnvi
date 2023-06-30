import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/empty_view.dart';
import '../components/news_cell.dart';
import '../detail/news_detail_screen.dart';
import '../../../../controllers/news_web_controller.dart';

class NewsWebScreen extends StatelessWidget {
  late final NewsWebController _controller = Get.put(NewsWebController());

  NewsWebScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
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
          controller: _controller.refreshController.value,
          onRefresh: _controller.onRefresh,
          onLoading: _controller.onLoading,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilter(),
                Obx(
                  () => _controller.newsList.toList().isEmpty
                      ? const EmptyView()
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return NewsCell(
                              newsModel: _controller.newsList.toList()[index],
                              onTap: () async {
                                Get.to(() => NewsDetailScreen(
                                      title: _controller.newsList
                                          .toList()[index]
                                          .title,
                                      url: _controller.newsList
                                          .toList()[index]
                                          .link,
                                    ));
                              },
                            );
                          },
                          itemCount: _controller.newsList.toList().length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        // physics: ClampingScrollPhysics(),
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Obx(
              () => FilterChip(
                  label: Text(_controller.listFilterStatusTxt[index]),
                  selected: _controller.filterSelected.value ==
                      _controller.listFilterStatusValue[index],
                  onSelected: (value) {
                    _controller.filterSelected.value =
                        _controller.listFilterStatusValue[index];
                    showLoading();
                    _controller.refresh().then((value) => {hideLoading()});
                  }),
            ),
          );
        },
        itemCount: _controller.listFilterStatusTxt.length,
      ),
    );
  }
}
