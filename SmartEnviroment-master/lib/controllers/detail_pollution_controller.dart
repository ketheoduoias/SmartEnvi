import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';
import 'package:pollution_environment/routes/app_pages.dart';

import '../services/commons/helper.dart';
import '../services/commons/recommend.dart';
import '../services/network/apis/pollution/pollution_api.dart';
import '../services/network/apis/users/user_api.dart';
import '../services/network/apis/waqi/waqi.dart';

class DetailPollutionController extends GetxController {
  late String pollutionId = Get.arguments;
  Rxn<UserModel> user = Rxn<UserModel>();
  Rxn<PollutionModel> pollutionModel = Rxn<PollutionModel>();
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  RxList<PollutionModel> historyPollutions = RxList<PollutionModel>();

  RxList<List<PollutionModel>> pollutions = RxList<List<PollutionModel>>();

  Rxn<WAQIIpResponse> aqiGPS = Rxn<WAQIIpResponse>();
  // MAP

  Completer<GoogleMapController> mapController = Completer();

  RxList<ClusterManager> managers = RxList<ClusterManager>();
  RxList<Set<Marker>> markers = [
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{}
  ].obs;

  RxInt recommentType = 0.obs;
  RxString recommend = "".obs;

  @override
  void onInit() {
    _initClusterManager();
    showLoading();
    Future.wait([getCurrentUser(), getPollution()]).then(
      (value) => hideLoading(),
    );
    super.onInit();
  }

  void _initClusterManager() {
    for (int i = 0; i < 6; i++) {
      pollutions.add([]);
      managers.add(ClusterManager<PollutionModel>(pollutions[i].toList(),
          (Set<Marker> markers) {
        this.markers.toList()[i].clear();
        this.markers.toList()[i].addAll(markers);
        this.markers.refresh();
      }, markerBuilder: _getMarkerBuilder(getQualityColor(i + 1))));
    }

    pollutions.refresh();
    managers.refresh();
  }

  Future<Marker> Function(Cluster<PollutionModel>) _getMarkerBuilder(
          Color color) =>
      (cluster) async {
        var firstPollution = cluster.items.first;
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: InfoWindow(
              title:
                  "${firstPollution.specialAddress ?? ""}, ${firstPollution.wardName ?? ""}, ${firstPollution.districtName ?? ""}, ${firstPollution.provinceName ?? ""}",
              snippet:
                  "Chất lượng ${getShortNamePollution(firstPollution.type)}: ${getQualityText(firstPollution.qualityScore)}",
              onTap: () {
                if (firstPollution.id != null) {
                  Get.offNamed(Routes.DETAIL_POLLUTION_SCREEN,
                      arguments: firstPollution.id, preventDuplicates: false);
                }
              }),
          onTap: () async {
            final GoogleMapController controller = await mapController.future;

            controller.showMarkerInfoWindow(MarkerId(cluster.getId()));
            if (cluster.isMultiple) {
              controller.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(firstPollution.lat!, firstPollution.lng!), 8));
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75, color,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };
  Future<BitmapDescriptor> _getMarkerBitmap(int size, Color color,
      {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = color.withOpacity(0.3);
    final Paint paint2 = Paint()..color = color;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.6, paint2);
    // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3.5,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<void> getCurrentUser() async {
    currentUser.value = UserStore().getAuth()?.user;
  }

  Future<void> getPollution() async {
    pollutionModel.value =
        await PollutionApi().getOnePollution(id: pollutionId);
    if (pollutionModel.value?.lat != null &&
        pollutionModel.value?.lng != null) {
      aqiGPS.value = await WaqiAPI()
          .getAQIByGPS(pollutionModel.value!.lat!, pollutionModel.value!.lng!);
      recommend.value =
          RecommendAQI.effectHealthy(aqiGPS.value?.data?.aqi ?? 0);
      final GoogleMapController controller = await mapController.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            pollutionModel.value!.lat!,
            pollutionModel.value!.lng!,
          ),
          zoom: 13)));
    }

    getUser();
    getHistoryPollution();
  }

  void getHistoryPollution() async {
    historyPollutions.value = await PollutionApi()
        .getPollutionHistory(pollutionModel.value?.districtId);
    _addMarker(historyPollutions.toList());
  }

  _addMarker(List<PollutionModel> list) async {
    for (int i = 0; i < 6; i++) {
      pollutions.toList()[i].clear();
    }
    for (var element in list) {
      if (element.lat != null &&
          element.lng != null &&
          element.type != null &&
          element.qualityScore != null) {
        pollutions.toList()[element.qualityScore! - 1].add(element);
      }
    }
    pollutions.refresh();
    for (int i = 0; i < 6; i++) {
      managers.toList()[i].setItems(pollutions[i].toList());
    }

    markers.refresh();
    managers.refresh();
  }

  void getUser() async {
    if (pollutionModel.value?.user != null) {
      user.value = await UserAPI().getUserById(pollutionModel.value!.user!);
    }
  }

  void changeStatus({required int status}) async {
    PollutionApi().updatePollution(id: pollutionId, status: status).then(
        (value) {
      pollutionModel.value = value;
      Fluttertoast.showToast(msg: "Cập nhật thông tin ô nhiễm thành công");
    }, onError: (e) {
      showAlert(desc: e.message);
    });
  }

  void deletePollution() async {
    PollutionApi().deletePollution(id: pollutionId).then((value) {
      Fluttertoast.showToast(
          msg: value.message ?? "Xóa thông tin ô nhiễm thành công");
      Get.back(result: "deleted");
    });
  }

  void changeRecommed() {
    if (recommentType.value == 0) {
      // Sức khỏe
      recommend.value =
          RecommendAQI.effectHealthy(aqiGPS.value?.data?.aqi ?? 0);
    } else if (recommentType.value == 1) {
      // Người bình thường
      recommend.value =
          RecommendAQI.actionNormalPeople(aqiGPS.value?.data?.aqi ?? 0);
    } else {
      recommend.value =
          RecommendAQI.actionSensitivePeople(aqiGPS.value?.data?.aqi ?? 0);
    }
  }
}
