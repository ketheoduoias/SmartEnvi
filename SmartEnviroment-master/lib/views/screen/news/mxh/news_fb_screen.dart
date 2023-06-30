import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/empty_view.dart';
import '../components/fb_post_cell.dart';
import '../detail/news_detail_screen.dart';
import '../../../../controllers/news_fb_controller.dart';

class NewsFBScreen extends StatelessWidget {
  final NewsFBController _controller = Get.put(NewsFBController());

  NewsFBScreen({Key? key}) : super(key: key);

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
          child: Obx(
            () => _controller.newsList.toList().isEmpty
                ? const EmptyView()
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return FBPostCell(
                        fbNews: _controller.newsList.toList()[index],
                        onTap: () async {
                          Get.to(
                            () => NewsDetailScreen(
                              url: _controller.newsList
                                  .toList()[index]
                                  .permalinkUrl,
                              title: _controller.newsList
                                  .toList()[index]
                                  .from
                                  ?.name,
                            ),
                          );
                        },
                      );
                    },
                    itemCount: _controller.newsList.toList().length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
          ),
        ),
      ),
    );
  }
}
