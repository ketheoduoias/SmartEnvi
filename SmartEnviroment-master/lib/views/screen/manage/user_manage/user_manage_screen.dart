import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/routes/app_pages.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../components/empty_view.dart';
import 'user_manage_controller.dart';

class UserManageScreen extends StatelessWidget {
  late final UserManageController _controller = Get.put(UserManageController());

  UserManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(5),
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
              children: [
                TextField(
                  controller: _controller.textEditController.value,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: "Nhập để tìm kiếm",
                    contentPadding: EdgeInsets.all(5),
                  ),
                  onChanged: (value) async {
                    _controller.onSearch(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => _controller.userList.toList().isEmpty
                      ? const EmptyView()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return _buildUserCard(
                                _controller.userList.toList()[index]);
                          },
                          itemCount: _controller.userList.toList().length,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel? userModel) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10000.0),
          child: CachedNetworkImage(
            imageUrl: userModel?.avatar ?? "",
            placeholder: (c, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (c, e, f) => const Center(
                child: Icon(
              Icons.person,
              size: 50,
            )),
            fit: BoxFit.fill,
            width: 50,
            height: 50,
          ),
        ),
        title: Text(userModel?.name ?? ""),
        subtitle: Text(userModel?.email ?? ""),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Get.toNamed(Routes.OTHER_PROFILE_SCREEN,
                  arguments: userModel?.id, preventDuplicates: false)
              ?.then((value) {
            _controller.refresh();
          });
        },
      ),
    );
  }
}
