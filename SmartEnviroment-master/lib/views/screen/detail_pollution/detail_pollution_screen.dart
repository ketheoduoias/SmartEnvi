import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pollution_environment/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

import '../../../services/commons/constants.dart';
import '../../../services/commons/generated/assets.dart';
import '../../../services/commons/helper.dart';
import '../../components/aqi_weather_card.dart';
import '../../components/full_image_viewer.dart';
import '../../components/pollution_card.dart';
import '../../components/pollution_user_card.dart';
import '../home/components/pollution_aqi_items.dart';
import 'components/history_chart.dart';
import '../../../controllers/detail_pollution_controller.dart';

class DetailPollutionScreen extends StatelessWidget {
  final DetailPollutionController _controller =
      Get.put(DetailPollutionController());

  final choices = [
    {'title': 'Duyệt', 'icon': const Icon(Icons.verified_rounded)},
    {'title': 'Từ chối', 'icon': const Icon(Icons.cancel_rounded)},
    {'title': 'Xóa', 'icon': const Icon(Icons.delete_rounded)},
  ];

  DetailPollutionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết ô nhiễm"), actions: <Widget>[
        Obx(() => (_controller.currentUser.value?.role == kRoleAdmin ||
                (_controller.currentUser.value?.role == kRoleMod &&
                    _controller.currentUser.value?.provinceManage.contains(
                            _controller.pollutionModel.value?.provinceId) ==
                        true))
            ? PopupMenuButton<String>(
                onSelected: handleClickMenu,
                itemBuilder: (BuildContext context) {
                  return choices.map((ch) {
                    return PopupMenuItem<String>(
                      value: ch['title'].toString(),
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          minLeadingWidth: 0,
                          leading: ch['icon'] as Widget,
                          title: Text(
                            ch['title'].toString(),
                          )),
                    );
                  }).toList();
                },
              )
            : IconButton(
                onPressed: () {
                  Share.share(
                      "Chất lượng không khí tại ${_controller.pollutionModel.value?.wardName ?? ""}, ${_controller.pollutionModel.value?.districtName ?? ""}, ${_controller.pollutionModel.value?.provinceName ?? ""} đang ${getQualityText(_controller.pollutionModel.value?.qualityScore)}. Xem chi tiết tại ứng dụng Smart Environment");
                },
                icon: const Icon(Icons.share_rounded))),
      ]),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              Text(
                _controller.pollutionModel.value?.specialAddress ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${_controller.pollutionModel.value?.wardName ?? ""}, ${_controller.pollutionModel.value?.districtName ?? ""}, ${_controller.pollutionModel.value?.provinceName ?? ""}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 10,
              ),
              _buildTypeCard(),
              _buildUserCard(),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      (_controller.pollutionModel.value?.status == 1)
                          ? Icons.verified_rounded
                          : (_controller.pollutionModel.value?.status == 2)
                              ? Icons.cancel_rounded
                              : Icons.timer_rounded,
                      color: (_controller.pollutionModel.value?.status == 1)
                          ? Colors.green
                          : (_controller.pollutionModel.value?.status == 2)
                              ? Colors.red
                              : Colors.orange,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      (_controller.pollutionModel.value?.status == 1)
                          ? "Đã được duyệt"
                          : (_controller.pollutionModel.value?.status == 2)
                              ? "Từ chối duyệt"
                              : "Đang chờ duyệt",
                      style: TextStyle(
                          color: (_controller.pollutionModel.value?.status == 1)
                              ? Colors.green
                              : (_controller.pollutionModel.value?.status == 2)
                                  ? Colors.red
                                  : Colors.orange),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_controller.aqiGPS.value != null)
                ExpandableNotifier(
                  child: Column(
                    children: [
                      Expandable(
                        collapsed: ExpandableButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Xem thêm chất lượng không khí",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        expanded: Column(
                          children: [
                            const Divider(),
                            AQIWeatherCard(aqi: _controller.aqiGPS.value!),
                            const SizedBox(
                              height: 8,
                            ),
                            const Divider(),
                            PollutionAqiItems(aqi: _controller.aqiGPS.value!),
                            const Divider(),
                            _buildRecommend(),
                            const SizedBox(
                              height: 10,
                            ),
                            ExpandableButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Thu gọn",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        theme: const ExpandableThemeData(
                            iconColor: Colors.red,
                            animationDuration: Duration(milliseconds: 500)),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              const Text(
                "Mô tả",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(_controller.pollutionModel.value?.desc ?? ""),
              const SizedBox(
                height: 8,
              ),
              if (_controller.pollutionModel.value?.images?.isNotEmpty == true)
                _buildImageView(),
              const SizedBox(
                height: 8,
              ),
              Obx(
                () => HistoryChart(
                  pollutions: _controller.historyPollutions.toList(),
                ),
              ),
              Card(
                child: SizedBox(
                  child: Obx(
                    () => GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                _controller.pollutionModel.value?.lat ?? 0.0,
                                _controller.pollutionModel.value?.lng ?? 0.0),
                            zoom: 13),
                        onMapCreated: (GoogleMapController controller) {
                          if (!_controller.mapController.isCompleted) {
                            _controller.mapController.complete(controller);
                          }
                          for (int i = 0; i < 6; i++) {
                            _controller.managers
                                .toList()[i]
                                .setMapId(controller.mapId);
                          }
                        },
                        onCameraMove: (position) {
                          for (int i = 0; i < 6; i++) {
                            _controller.managers
                                .toList()[i]
                                .onCameraMove(position);
                          }
                        },
                        onCameraIdle: () {
                          for (int i = 0; i < 6; i++) {
                            _controller.managers.toList()[i].updateMap();
                          }
                        },
                        markers: <Marker>{}
                          ..addAll(_controller.markers.toList()[0])
                          ..addAll(_controller.markers.toList()[1])
                          ..addAll(_controller.markers.toList()[2])
                          ..addAll(_controller.markers.toList()[3])
                          ..addAll(_controller.markers.toList()[4])
                          ..addAll(_controller.markers.toList()[5])),
                  ),
                  height: 250,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        child: CachedNetworkImage(
          imageUrl: _controller.pollutionModel.value?.images![index] ?? "",
          placeholder: (c, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (c, e, f) => const Center(child: Icon(Icons.error)),
          fit: BoxFit.fill,
        ),
        onTap: () {
          Get.to(() => FullImageViewer(
                url: _controller.pollutionModel.value?.images![index] ?? "",
              ));
        },
      ),
      physics:
          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      itemCount: _controller.pollutionModel.value?.images?.length ?? 0,
    );
  }

  Widget _buildUserCard() {
    return GestureDetector(
      child: PollutionUserCard(
        userModel: _controller.user.value,
        createdAt: _controller.pollutionModel.value?.createdAt,
      ),
      onTap: () {
        Get.toNamed(Routes.OTHER_PROFILE_SCREEN,
            arguments: _controller.user.value?.id, preventDuplicates: false);
      },
    );
  }

  Widget _buildTypeCard() {
    return _controller.pollutionModel.value != null
        ? PollutionCard(pollutionModel: _controller.pollutionModel.value!)
        : Container();
  }

  Widget _buildRecommend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Khuyến nghị",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.recommentType.value = 0;
                  _controller.changeRecommed();
                },
                child: Card(
                  elevation: 3,
                  color: _controller.recommentType.value == 0
                      ? getQualityColor(getAQIRank(
                          (_controller.aqiGPS.value?.data?.aqi ?? 0)
                              .toDouble()))
                      : null,
                  child: SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            Assets.healthy,
                            height: 32,
                            width: 32,
                          ),
                          const Expanded(
                            child: Text(
                              "Sức khỏe",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.recommentType.value = 1;
                  _controller.changeRecommed();
                },
                child: Card(
                  color: _controller.recommentType.value == 1
                      ? getQualityColor(getAQIRank(
                          (_controller.aqiGPS.value?.data?.aqi ?? 0)
                              .toDouble()))
                      : null,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Assets.normalPeople,
                          height: 32,
                          width: 32,
                        ),
                        const Expanded(
                          child: Text(
                            "Người bình thường",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.recommentType.value = 2;
                  _controller.changeRecommed();
                },
                child: Card(
                  color: _controller.recommentType.value == 2
                      ? getQualityColor(getAQIRank(
                          (_controller.aqiGPS.value?.data?.aqi ?? 0)
                              .toDouble()))
                      : null,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          Assets.sensitivePeople,
                          height: 32,
                          width: 32,
                        ),
                        const Expanded(
                          child: Text(
                            "Người nhạy cảm",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 3,
          color: getQualityColor(getAQIRank(
              (_controller.aqiGPS.value?.data?.aqi ?? 0).toDouble())),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _controller.recommend.value,
                style: TextStyle(
                    color: getTextColorRank(getAQIRank(
                        (_controller.aqiGPS.value?.data?.aqi ?? 0)
                            .toDouble()))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void handleClickMenu(String value) {
    switch (value) {
      case 'Duyệt':
        _controller.changeStatus(status: 1);
        break;
      case 'Từ chối':
        _controller.changeStatus(status: 2);
        break;
      case 'Xóa':
        _controller.deletePollution();
        break;
    }
  }
}
