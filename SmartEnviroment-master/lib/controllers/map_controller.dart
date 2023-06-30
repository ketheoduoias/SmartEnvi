import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/model/waqi/waqi_map_model.dart';

import '../services/commons/helper.dart';
import '../services/commons/location_service.dart';
import '../services/network/apis/pollution/pollution_api.dart';
import '../services/network/apis/waqi/waqi.dart';
import 'filter_storage_controller.dart';

class MapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800));
  late Animation<Offset> offset;

  final FilterStorageController filterStorageController =
      Get.put(FilterStorageController());

  Completer<GoogleMapController> mapController = Completer();

  RxList<ClusterManager> managers = RxList<ClusterManager>();
  RxSet<Polygon> polygons = RxSet<Polygon>();
  List<LatLng> polygonLatLngs = [];
  RxList<Set<Marker>> markers = [
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{}
  ].obs;

  RxList<List<PollutionModel>> pollutions = RxList<List<PollutionModel>>();

  Rxn<PollutionModel> pollutionSelected = Rxn<PollutionModel>();
  Rxn<WAQIMapData> aqiMarkerSelected = Rxn<WAQIMapData>();

  RxList<List<WAQIMapData>> aqiPointMarkers = RxList<List<WAQIMapData>>();
  RxList<ClusterManager> aqiManagers = RxList<ClusterManager>();
  RxList<Set<Marker>> aqiMarkers = [
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{},
    <Marker>{}
  ].obs;

  Rx<AuthResponse?> currentUser = UserStore().getAuth().obs;
  Timer? _debounce;
  Timer? _debouncePollution;

  @override
  void onInit() {
    getPos();
    offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0.0, 1.0))
        .animate(animationController);
    getPollutionPosition();
    setPolygon();
    getAQIMap();
    _initClusterManager();
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
    for (int i = 0; i < 6; i++) {
      aqiPointMarkers.add([]);
      aqiManagers.add(ClusterManager<WAQIMapData>(aqiPointMarkers[i].toList(),
          (Set<Marker> markers) {
        aqiMarkers.toList()[i].clear();
        aqiMarkers.toList()[i].addAll(markers);
        aqiMarkers.refresh();
      }, markerBuilder: _getAQIMarkerBuilder(getQualityColor(i + 1))));
    }

    pollutions.refresh();
    managers.refresh();

    aqiPointMarkers.refresh();
    aqiManagers.refresh();
  }

  Future<Marker> Function(Cluster<PollutionModel>) _getMarkerBuilder(
          Color color) =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            var firstPollution = cluster.items.first;
            pollutionSelected.value = firstPollution;
            aqiMarkerSelected.value = null;
            if (cluster.isMultiple) {
              final GoogleMapController controller = await mapController.future;

              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(firstPollution.lat!, firstPollution.lng!),
                      zoom: 13)));
            }
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75, color,
              cluster.items.first.status ?? 0,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<Marker> Function(Cluster<WAQIMapData>) _getAQIMarkerBuilder(
          Color color) =>
      (cluster) async {
        var firstAQI = cluster.items.first;
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            aqiMarkerSelected.value = firstAQI;
            pollutionSelected.value = null;
            if (cluster.isMultiple) {
              final GoogleMapController controller = await mapController.future;

              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(firstAQI.lat!, firstAQI.lon!), zoom: 13)));
            }
          },
          icon: await _getAQIMarkerBitmap(cluster.isMultiple ? 125 : 100,
              firstAQI.aqi == "-" ? const Color(0x80808080) : color,
              text: firstAQI.aqi == "-"
                  ? "-"
                  : cluster.isMultiple
                      ? "${firstAQI.aqi ?? "-"}+"
                      : firstAQI.aqi ?? "-"),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, Color color, int status,
      {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = color.withOpacity(0.3);
    final Paint paint2 = Paint()..color = color;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.6, paint2);

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
    if (status == 0) {
      // Đang chờ duyệt
      const String rawSvg =
          '''<svg width="34px" height="34px" viewBox="0 0 34 34" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>wait-1.1s-200px</title>
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round">
        <g id="wait-1.1s-200px" transform="translate(2.000000, 2.000000)" stroke="#00C800" stroke-width="4">
            <circle id="Oval" fill="#FFFFFF" fill-rule="nonzero" cx="15" cy="15" r="15"></circle>
            <line x1="15" y1="5.82857143" x2="15" y2="15" id="Path"></line>
            <line x1="21" y1="18.5142857" x2="15" y2="15" id="Path"></line>
        </g>
    </g>
</svg>''';
      final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
      // svgRoot.scaleCanvasToViewBox(
      //     canvas, Size(size.toDouble() / 2, size.toDouble() / 2));
      // svgRoot.clipCanvasToViewBox(canvas);

      svgRoot.draw(
          canvas, Rect.fromPoints(const Offset(0, 0), const Offset(30, 30)));
    } else if (status == 2) {
      // Từ chối duyệt
      const String rawSvg =
          '''<svg width="51px" height="51px" viewBox="0 0 51 51" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>2a0ac4c7-6508-4f23-a825-5f08c62a95de</title>
    <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="2a0ac4c7-6508-4f23-a825-5f08c62a95de" transform="translate(0.125175, 0.126503)" fill-rule="nonzero">
            <circle id="Oval" fill="#FFFFFF" transform="translate(25.000000, 25.000000) rotate(-45.000000) translate(-25.000000, -25.000000) " cx="25" cy="25" r="17.6776695"></circle>
            <path d="M38.6348134,11.3652866 C33.7880009,6.3746765 26.6289201,4.38144008 19.9004249,6.14924476 C13.1719297,7.91704944 7.91714948,13.1718296 6.1493448,19.9003248 C4.38154012,26.62882 6.37477654,33.7879009 11.3653867,38.6347134 C16.2121992,43.6253235 23.37128,45.6185599 30.0997752,43.8507552 C36.8282704,42.0829506 42.0830506,36.8281704 43.8508553,30.0996752 C45.61866,23.37118 43.6254235,16.2120991 38.6348134,11.3652866 Z M36.3636167,36.3635166 C30.0877197,42.6394136 19.9124803,42.6394136 13.6365834,36.3635166 C7.36068646,30.0876197 7.36068646,19.9123803 13.6365834,13.6364834 C19.9124803,7.36058642 30.0877197,7.36058642 36.3636167,13.6364834 C42.6395136,19.9123803 42.6395136,30.0876197 36.3636167,36.3635166 L36.3636167,36.3635166 Z" id="Shape" fill="#AA0000"></path>
            <path d="M30.9571892,19.0429109 C30.6558434,18.7414687 30.247073,18.5721121 29.8208375,18.5721121 C29.3946021,18.5721121 28.9858316,18.7414687 28.6844858,19.0429109 L25.0001,22.7272967 L21.3149609,19.0421576 C20.9089816,18.6361782 20.3172538,18.4776252 19.7626757,18.6262239 C19.2080976,18.7748227 18.7749227,19.2079975 18.626324,19.7625756 C18.4777252,20.3171538 18.6362782,20.9088816 19.0422576,21.3148609 L22.7273967,25 L19.0422576,28.6851391 C18.6362782,29.0911184 18.4777252,29.6828462 18.626324,30.2374244 C18.7749227,30.7920025 19.2080976,31.2251773 19.7626757,31.3737761 C20.3172538,31.5223748 20.9089816,31.3638218 21.3149609,30.9578424 L25.0001,27.2727033 L28.6852391,30.9578424 C29.0912185,31.3638218 29.6829463,31.5223748 30.2375244,31.3737761 C30.7921025,31.2251773 31.2252773,30.7920025 31.3738761,30.2374244 C31.5224748,29.6828462 31.3639218,29.0911184 30.9579425,28.6851391 L27.2728034,25 L30.9579425,21.3148609 C31.584964,20.6872082 31.5846267,19.6701476 30.9571892,19.0429109 L30.9571892,19.0429109 Z" id="Path" fill="#AA0000"></path>
        </g>
    </g>
</svg>''';
      final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
      // svgRoot.scaleCanvasToViewBox(
      //     canvas, Size(size.toDouble() / 2, size.toDouble() / 2));
      // svgRoot.clipCanvasToViewBox(canvas);

      svgRoot.draw(
          canvas, Rect.fromPoints(const Offset(0, 0), const Offset(30, 30)));
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _getAQIMarkerBitmap(int size, Color color,
      {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.white;
    final Paint paint2 = Paint()..color = color;

    final path = Path();
    Rect rect = Rect.fromPoints(const Offset(0, 0),
        Offset(size.toDouble(), size.toDouble()) - const Offset(0, 20));
    path
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
      ..moveTo(rect.bottomCenter.dx - 15, rect.bottomCenter.dy)
      ..relativeLineTo(15, 20)
      ..relativeLineTo(15, -20);
    path.close();
    canvas.drawPath(path, paint2);

    final path2 = Path();
    Rect rect2 = Rect.fromPoints(const Offset(5, 5),
        Offset(size.toDouble() - 5, size.toDouble() - 5) - const Offset(0, 23));
    path2
      ..addRRect(
          RRect.fromRectAndRadius(rect2, Radius.circular(rect2.height / 2)))
      ..moveTo(rect2.bottomCenter.dx - 10, rect2.bottomCenter.dy)
      ..relativeLineTo(10, 15)
      ..relativeLineTo(10, -15);
    path2.close();
    canvas.drawPath(path2, paint1);

    final path3 = Path();
    Rect rect3 = Rect.fromPoints(const Offset(8, 8),
        Offset(size.toDouble() - 8, size.toDouble() - 8) - const Offset(0, 23));
    path3
      ..addRRect(
          RRect.fromRectAndRadius(rect3, Radius.circular(rect3.height / 2)))
      ..moveTo(rect3.bottomCenter.dx - 13, rect3.bottomCenter.dy);
    path3.close();
    canvas.drawPath(path3, paint2);

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
        Offset(
            size / 2 - painter.width / 2, size / 2 - painter.height / 2 - 10),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(20.9109654, 105.8113753),
    zoom: 14.4746,
  );

  void getPos() async {
    Position position = await LocationService().determinePosition();
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 13)));
  }

  getAQIMap() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (filterStorageController.isFilterAQI.value) {
        var map = await mapController.future;
        var bounds = await map.getVisibleRegion();
        var aqiResponse = await WaqiAPI().getAQIMap(
            bounds.northeast.latitude,
            bounds.northeast.longitude,
            bounds.southwest.latitude,
            bounds.southwest.longitude);
        for (int i = 0; i < 6; i++) {
          aqiPointMarkers.toList()[i].clear();
        }
        aqiResponse.data?.forEach((element) {
          num aqi = int.tryParse(element.aqi ?? "0") ?? 0;
          if (aqi >= 0 && aqi <= 50) aqiPointMarkers.toList()[5].add(element);
          if (aqi >= 51 && aqi <= 100) aqiPointMarkers.toList()[4].add(element);
          if (aqi >= 101 && aqi <= 150) {
            aqiPointMarkers.toList()[3].add(element);
          }
          if (aqi >= 151 && aqi <= 200) {
            aqiPointMarkers.toList()[2].add(element);
          }
          if (aqi >= 201 && aqi <= 300) {
            aqiPointMarkers.toList()[1].add(element);
          }
          if (aqi >= 301) aqiPointMarkers.toList()[0].add(element);
        });
        aqiPointMarkers.refresh();
        for (int i = 0; i < 6; i++) {
          aqiManagers.toList()[i].setItems(aqiPointMarkers[i].toList());
        }
      } else {
        for (int i = 0; i < 6; i++) {
          aqiPointMarkers.toList()[i].clear();
          aqiManagers.toList()[i].setItems(aqiPointMarkers[i].toList());
          aqiMarkers.toList()[i].clear();
        }
        aqiPointMarkers.refresh();
      }

      aqiMarkers.refresh();
      aqiManagers.refresh();
    });
  }

  getPollutionPosition() async {
    if (_debouncePollution?.isActive ?? false) _debouncePollution?.cancel();
    _debouncePollution = Timer(const Duration(milliseconds: 300), () async {
      final DateTime now = DateTime.now();
      final sevenDayAgo = DateTime(now.year, now.month, now.day - 7);
      final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
      final String sevenDayAgoStr = formatter.format(sevenDayAgo);

      PollutionsResponse? pollutionsResponse;
      if (filterStorageController.selectedType
          .toList()
          .map((e) => e.key ?? "")
          .toList()
          .isNotEmpty) {
        pollutionsResponse = await PollutionApi().getAllPollution(
            limit: 1000,
            provinceName:
                filterStorageController.selectedProvince.value?.id == "-1"
                    ? null
                    : filterStorageController.selectedProvince.value?.name,
            districtName:
                filterStorageController.selectedDistrict.value?.id == "-1"
                    ? null
                    : filterStorageController.selectedDistrict.value?.name,
            wardName: filterStorageController.selectedWard.value?.id == "-1"
                ? null
                : filterStorageController.selectedWard.value?.name,
            type: filterStorageController.selectedType
                .toList()
                .map((e) => e.key ?? "")
                .toList(),
            quality: filterStorageController.selectedQuality
                .toList()
                .map((e) => e.key ?? "")
                .toList(),
            status: (currentUser.value?.user?.role == "admin" ||
                    currentUser.value?.user?.role == "mod")
                ? null
                : 1,
            startDate: sevenDayAgoStr);
      }
      var list = pollutionsResponse?.results ?? [];

      _addMarker(list);
    });
  }

  void setPolygon() async {
    String id =
        "${filterStorageController.selectedProvince.value?.id}${filterStorageController.selectedDistrict.value?.id}";
    await _setPolygon(id);
  }

// Draw Polygon to the map
  Future<void> _setPolygon(String id) async {
    var polygon = filterStorageController.polygon.toList();
    var bbox = filterStorageController.bbox.toList();
    polygonLatLngs.clear();
    for (var element in polygon) {
      polygonLatLngs.add(LatLng(element.last, element.first));
    }
    polygons.clear();
    if (polygonLatLngs.length > 3) {
      polygons.add(Polygon(
        polygonId: PolygonId(id),
        points: polygonLatLngs,
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: Colors.yellow.withOpacity(0.75),
      ));
    }

    polygons.refresh();
    if (bbox.length == 4) {
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(bbox[1], bbox[0]),
              northeast: LatLng(bbox[3], bbox[2])),
          5));
    }
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

  @override
  void dispose() {
    _debounce?.cancel();
    _debouncePollution?.cancel();
    super.dispose();
  }
}
