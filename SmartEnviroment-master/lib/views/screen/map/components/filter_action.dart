import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pollution_environment/model/pollution_response.dart';

import '../../../../services/commons/helper.dart';
import '../../../components/empty_view.dart';
import '../../detail_pollution/detail_pollution_screen.dart';
import '../../../../controllers/map_controller.dart';

class FilterAction extends StatelessWidget {
  const FilterAction({
    Key? key,
    required MapController controller,
  })  : _controller = controller,
        super(key: key);

  final MapController _controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 40,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            right: 5,
            left: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: IconButton(
                focusColor: Colors.green,
                icon: const Icon(
                  Icons.gps_fixed_rounded,
                ),
                onPressed: () {
                  _controller.getPos();
                },
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    // color: getQualityColor(index + 1),
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _controller.filterStorageController.isFilterAQI.value
                              ? Text(getQualityAQIText(index + 1),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))
                              : Text(
                                  getQualityText(index + 1),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                          if (_controller
                              .filterStorageController.isFilterAQI.value)
                            Text(
                              getAqiFromQuality(index + 1),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: index == 5
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            )
                          : index == 0
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                )
                              : null,
                      color: getQualityColor(index + 1),
                    ),
                  );
                },
                itemCount: 6,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              child: IconButton(
                icon: const Icon(
                  Icons.list_rounded,
                ),
                onPressed: () {
                  showBarModalBottomSheet(
                    barrierColor: Colors.black54,
                    context: context,
                    builder: (ctx) {
                      var list = _controller.pollutions
                          .toList()
                          .expand((element) => element)
                          .toList();
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Scaffold(
                          appBar: AppBar(
                            title: const Text("Danh sách ô nhiễm"),
                            automaticallyImplyLeading: false,
                            centerTitle: true,
                          ),
                          body: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              itemBuilder: (c, i) {
                                if (list.isEmpty) {
                                  return const EmptyView();
                                } else {
                                  return buildRow(c, list[i]);
                                }
                              },
                              itemCount: list.isEmpty ? 1 : list.length,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, PollutionModel pollution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          // Vào màn xem chi tiết
          Get.to(() => DetailPollutionScreen(), arguments: pollution.id);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Image.asset(
                  getAssetPollution(pollution.type),
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pollution.specialAddress ?? "",
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${pollution.wardName}, ${pollution.districtName}, ${pollution.provinceName}",
                        style: Theme.of(context).textTheme.subtitle1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_controller.currentUser.value?.user?.role ==
                              "admin" ||
                          (_controller.currentUser.value?.user?.role == "mod" &&
                              _controller
                                      .currentUser.value?.user?.provinceManage
                                      .contains(pollution.provinceId) ==
                                  true))
                        Text(
                          pollution.status == 0
                              ? "Đang chờ phê duyệt"
                              : (pollution.status == 1
                                  ? "Đã duyệt"
                                  : "Từ chối duyệt"),
                          style: TextStyle(
                              color: pollution.status == 0
                                  ? Colors.orange
                                  : pollution.status == 1
                                      ? Colors.green
                                      : Colors.red,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.fontSize),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      final GoogleMapController controller =
                          await _controller.mapController.future;

                      controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(pollution.lat!, pollution.lng!),
                              zoom: 17)));
                      Get.back();
                    },
                    icon: const Icon(Icons.location_pin))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
