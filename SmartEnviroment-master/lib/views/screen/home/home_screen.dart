import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pollution_environment/routes/app_pages.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../services/commons/constants.dart';
import '../../../services/commons/generated/assets.dart';
import '../../../services/commons/helper.dart';
import '../../components/aqi_weather_card.dart';
import '../detail_aqi/detail_aqi_screen.dart';
import '../../../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Environment"),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.NOTIFICATION_SCREEN);
              },
              icon: const Icon(
                Icons.notifications_active,
                size: 30,
                color: Colors.yellow,
              )),
          if (_controller.currentUser?.value.role == kRoleAdmin ||
              _controller.currentUser?.value.role == kRoleMod)
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.MANAGE_SCREEN);
              },
              icon: SvgPicture.asset(
                Assets.dashboard,
                height: 30,
                width: 30,
                color: Colors.yellow,
              ),
            ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE_SCREEN),
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                imageUrl: _controller.currentUser?.value.avatar ?? "",
                height: 30,
                width: 30,
                fit: BoxFit.fill,
                placeholder: (ctx, str) {
                  return Image.asset(Assets.profileAvatar);
                },
                errorWidget: (ctx, str, _) {
                  return Image.asset(Assets.profileAvatar);
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const ClassicHeader(
            idleText: "Kéo để làm mới",
            refreshingText: "Đang tải...",
            releaseText: "Kéo để làm mới",
            completeText: "Lấy dữ liệu thành công",
            refreshStyle: RefreshStyle.Follow,
          ),
          controller: _controller.refreshController.value,
          onRefresh: _controller.onRefreshData,
          child: ListView(
            children: [
              Column(
                children: [
                  Obx(
                    () => Text(
                      _controller.currentAQI.value?.data?.city?.name ?? "",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Obx(
                    () => Text(
                      _controller.currentAQI.value?.data?.city?.location ?? "",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _buildAQICard(),
              const SizedBox(
                height: 10,
              ),
              Align(
                child: SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(Routes.FAVORITE_SCREEN);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                    ),
                    child: const Text("THÊM MỘT NƠI MỚI"),
                  ),
                ),
              ),
              const Divider(),
              favoriteWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAQICard() {
    return Obx(() => _controller.currentAQI.value != null
        ? GestureDetector(
            onTap: () {
              Get.to(() => DetailAQIScreen(),
                  arguments: _controller.currentAQI.value?.data?.idx);
            },
            child: AQIWeatherCard(aqi: _controller.currentAQI.value!),
          )
        : Container());
  }

  Widget favoriteWidget() {
    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _controller.favoriteAqis.values.toList().length,
        itemBuilder: (ctx, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8),
            title: Text(_controller.favoriteAqis.keys.toList()[index]),
            subtitle: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  AQIWeatherCard(
                      aqi: _controller.favoriteAqis.values.toList()[index]),
                ]),
                Positioned(
                  right: -5,
                  child: IconButton(
                    onPressed: () {
                      showAlert(
                        desc: "Bạn có chắc muốn xóa địa điểm này?",
                        onConfirm: () {
                          _controller.removeFavorite(index);
                        },
                      );
                    },
                    icon: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(13)),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => DetailAQIScreen(),
                  arguments: _controller.favoriteAqis.values
                      .toList()[index]
                      .data
                      ?.idx);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }
}
