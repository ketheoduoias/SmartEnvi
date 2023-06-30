import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pollution_environment/model/pollution_type_model.dart';

import '../../../services/commons/generated/assets.dart';
import '../../../services/commons/helper.dart';
import '../filter/filter_screen.dart';
import 'components/filter_action.dart';
import 'components/get_map.dart';
import 'components/map_filter_model.dart';
import 'components/map_remote_data.dart';
import 'components/view_aqi_selected.dart';
import 'components/view_pollution_selected.dart';
import '../../../controllers/map_controller.dart';

class MapScreen extends StatelessWidget {
  late final MapController _controller = Get.put(MapController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Obx(
        () => (_controller.pollutionSelected.value == null &&
                _controller.aqiMarkerSelected.value == null)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SpeedDial(
                      icon: Icons.filter_list_outlined, activeIcon: Icons.close,
                      spacing: 3,
                      direction: SpeedDialDirection.up,
                      childPadding: const EdgeInsets.all(5),
                      spaceBetweenChildren: 4,
                      tooltip: 'Bộ lọc',
                      heroTag: 'speed-dial-hero-tag',
                      elevation: 8.0,
                      isOpenOnStart: false,
                      animationSpeed: 200,
                      shape: const StadiumBorder(),
                      // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      children: [
                        _buildFilterPollutionButton("land"),
                        _buildFilterPollutionButton("water"),
                        _buildFilterPollutionButton("air"),
                        _buildFilterPollutionButton("sound"),
                        SpeedDialChild(
                          child: const Icon(Icons.read_more_rounded),
                          label: 'Nhiều hơn',
                          backgroundColor: Colors.green,
                          labelBackgroundColor: Colors.green,
                          visible: true,
                          onTap: () {
                            Get.to(FilterMapScreen())?.then((value) {
                              _controller.getPollutionPosition();
                              _controller.setPolygon();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SpeedDial(
                      icon: Icons.layers_outlined, activeIcon: Icons.close,
                      spacing: 3,
                      direction: SpeedDialDirection.up,
                      childPadding: const EdgeInsets.all(5),
                      spaceBetweenChildren: 4,
                      tooltip: 'Bản đồ',
                      heroTag: 'speed-dial-map-layer',
                      elevation: 8.0,
                      isOpenOnStart: false,
                      animationSpeed: 200,
                      shape: const StadiumBorder(),
                      // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      children: [
                        SpeedDialChild(
                          child: SvgPicture.asset(
                            Assets.cloudy,
                            height: 30,
                            width: 30,
                            color: Colors.green,
                          ),
                          backgroundColor: _controller
                                  .filterStorageController.isFilterAQI.value
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.isFilterAQI.value
                              ? Colors.lightBlue.shade300
                              : null,
                          label: 'Chất lượng không khí',
                          foregroundColor: Colors.green,
                          visible: true,
                          onTap: () async {
                            _controller
                                    .filterStorageController.isFilterAQI.value =
                                !_controller
                                    .filterStorageController.isFilterAQI.value;
                            await _controller.getAQIMap();
                          },
                        ),
                        SpeedDialChild(
                          child: const Text("PM25"),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.pm25)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.pm25)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'PM25',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.pm25)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.pm25)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.pm25);
                          },
                        ),
                        SpeedDialChild(
                          child: const Text("PM10"),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.pm10)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.pm10)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'PM10',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.pm10)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.pm10)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.pm10);
                          },
                        ),
                        SpeedDialChild(
                          child: const Text("O3"),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.o3)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.o3)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'O3',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.o3)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.o3)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.o3);
                          },
                        ),
                        SpeedDialChild(
                          child: const Text("CO"),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.co)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.co)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'CO',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.co)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.co)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.co);
                          },
                        ),
                        SpeedDialChild(
                          child: const Icon(Icons.speed),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.wind)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.wind)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'Tốc độ gió',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.wind)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.wind)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.wind);
                          },
                        ),
                        SpeedDialChild(
                          child: SvgPicture.asset(
                            Assets.thermometer,
                            height: 30,
                            width: 30,
                            color: Colors.red,
                          ),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.temperature)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.temperature)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.red,
                          label: 'Nhiệt độ',
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.temperature)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.temperature)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.temperature);
                          },
                        ),
                        SpeedDialChild(
                          child: SvgPicture.asset(
                            Assets.raining,
                            height: 30,
                            width: 30,
                            color: Colors.grey,
                          ),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.accumulated)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.accumulated)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.orange,
                          label: 'Lượng mưa',
                          visible: true,
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.accumulated)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.accumulated)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.accumulated);
                          },
                        ),
                        SpeedDialChild(
                          child: SvgPicture.asset(
                            Assets.water,
                            height: 30,
                            width: 30,
                            color: Colors.blue,
                          ),
                          backgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.humidity)
                              ? Colors.lightBlue.shade300
                              : null,
                          labelBackgroundColor: _controller
                                  .filterStorageController.mapLayer
                                  .contains(MapLayerFilterValue.humidity)
                              ? Colors.lightBlue.shade300
                              : null,
                          foregroundColor: Colors.blue,
                          label: 'Độ ẩm',
                          visible: true,
                          onTap: () {
                            _controller.filterStorageController.mapLayer
                                    .contains(MapLayerFilterValue.humidity)
                                ? _controller.filterStorageController.mapLayer
                                    .remove(MapLayerFilterValue.humidity)
                                : _controller.filterStorageController.mapLayer
                                    .add(MapLayerFilterValue.humidity);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ),
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: _controller.kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.mapController.complete(controller);
                  for (int i = 0; i < 6; i++) {
                    _controller.managers.toList()[i].setMapId(controller.mapId);
                    _controller.aqiManagers
                        .toList()[i]
                        .setMapId(controller.mapId);
                  }
                },
                onCameraMove: (position) {
                  for (int i = 0; i < 6; i++) {
                    _controller.managers.toList()[i].onCameraMove(position);
                    _controller.aqiManagers.toList()[i].onCameraMove(position);
                  }
                  _controller.getPollutionPosition();
                  _controller.getAQIMap();
                },
                onCameraIdle: () {
                  for (int i = 0; i < 6; i++) {
                    _controller.managers.toList()[i].updateMap();
                    _controller.aqiManagers.toList()[i].updateMap();
                  }
                },
                onTap: (latlng) {
                  if (_controller.pollutionSelected.value?.lat !=
                          latlng.latitude &&
                      _controller.pollutionSelected.value?.lng !=
                          latlng.longitude &&
                      _controller.aqiMarkerSelected.value?.location.latitude !=
                          latlng.latitude &&
                      _controller.aqiMarkerSelected.value?.location.longitude !=
                          latlng.longitude) {
                    _controller.animationController.forward();
                    _controller.pollutionSelected.value = null;
                    _controller.aqiMarkerSelected.value = null;
                  }
                },
                tileOverlays: _controller.filterStorageController.mapLayer
                    .toSet()
                    .map((e) => TileOverlay(
                        tileOverlayId: TileOverlayId(e.value),
                        tileProvider: tileProvider(e)))
                    .toSet(),
                polygons: _controller.polygons.toSet(),
                markers: <Marker>{}
                  ..addAll(_controller.markers.toList()[0])
                  ..addAll(_controller.markers.toList()[1])
                  ..addAll(_controller.markers.toList()[2])
                  ..addAll(_controller.markers.toList()[3])
                  ..addAll(_controller.markers.toList()[4])
                  ..addAll(_controller.markers.toList()[5])
                  ..addAll(_controller.aqiMarkers.toList()[0])
                  ..addAll(_controller.aqiMarkers.toList()[1])
                  ..addAll(_controller.aqiMarkers.toList()[2])
                  ..addAll(_controller.aqiMarkers.toList()[3])
                  ..addAll(_controller.aqiMarkers.toList()[4])
                  ..addAll(_controller.aqiMarkers.toList()[5])),
          ),
          _buildStatusView(),
          Obx(() => _controller.pollutionSelected.value != null
              ? _buildViewPollutionSelected()
              : Container()),
          Obx(() => _controller.aqiMarkerSelected.value != null
              ? _buildViewAQISelected()
              : Container())
        ],
      ),
    );
  }

  Widget _buildViewPollutionSelected() {
    if (_controller.pollutionSelected.value != null) {
      _controller.animationController.reverse();
    } else {
      _controller.animationController.forward();
    }
    return ViewPollutionSelected(
      offset: _controller.offset,
      pollutionSelected: _controller.pollutionSelected.value,
      currentUser: _controller.currentUser.value?.user,
    );
  }

  Widget _buildViewAQISelected() {
    if (_controller.aqiMarkerSelected.value != null) {
      _controller.animationController.reverse();
    } else {
      _controller.animationController.forward();
    }
    return ViewAQISelected(controller: _controller);
  }

  Widget _buildStatusView() {
    return FilterAction(controller: _controller);
  }

  SpeedDialChild _buildFilterPollutionButton(String type) {
    return SpeedDialChild(
      child: Image.asset(
        getAssetPollution(type),
        height: 30,
        width: 30,
      ),
      backgroundColor: _controller.filterStorageController.selectedType
                  .toList()
                  .firstWhereOrNull((element) => element.key == type) !=
              null
          ? Colors.lightBlue.shade300
          : null,
      labelBackgroundColor: _controller.filterStorageController.selectedType
                  .toList()
                  .firstWhereOrNull((element) => element.key == type) !=
              null
          ? Colors.lightBlue.shade300
          : null,
      label: getNamePollution(type),
      visible: true,
      onTap: () {
        _controller.filterStorageController.selectedType
                    .toList()
                    .firstWhereOrNull((element) => element.key == type) !=
                null
            ? _controller.filterStorageController.selectedType
                .removeWhere((element) => element.key == type)
            : _controller.filterStorageController.selectedType.add(
                PollutionType(key: type, name: getShortNamePollution(type)));
        _controller.getPollutionPosition();
      },
    );
  }

  TileProvider tileProvider(MapFilterModel mapType) {
    return GetMap(
      mapType: mapType,
      mapRemoteDataSource: MapRemoteDataSourceImpl(),
    );
  }
}
