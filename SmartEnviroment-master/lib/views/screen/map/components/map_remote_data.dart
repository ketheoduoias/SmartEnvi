import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../../../services/network/apis/waqi/waqi.dart';
import '../../../../services/network/apis/weather/weather.dart';
import 'map_filter_model.dart';

abstract class MapRemoteDataSource {
  Future<MapModel> getMaps(MapFilterModel mapType, int x, int y, int zoom);
}

class MapRemoteDataSourceImpl extends MapRemoteDataSource {
  @override
  Future<MapModel> getMaps(
      MapFilterModel mapType, int x, int y, int zoom) async {
    try {
      // final uri = Uri.parse(
      //     "https://tile.openweathermap.org/map/$mapType/$zoom/$x/$y.png?appid=${WeatherPath.kWeather}");
      late Uri uri;
      if (mapType.type == MapFilterType.layer) {
        uri = Uri.parse(
            "https://maps.openweathermap.org/maps/2.0/weather/${mapType.value}/$zoom/$x/$y?fill_bound=true&use_norm=true&arrow_step=16&appid=${WeatherPath.kWeatherEdu}");
      } else {
        uri = Uri.parse(
            "https://tiles.aqicn.org/tiles/${mapType.value}/$zoom/$x/$y.png?token=${WaqiAPIPath.kToken}");
      }

      final ByteData imageData = await NetworkAssetBundle(uri).load("");
      return MapModel.fromByteData(imageData);
    } catch (e) {
      rethrow;
    }
  }
}

class MapModel extends Maps {
  const MapModel({required Uint8List uint8list}) : super(uint8list: uint8list);

  factory MapModel.fromByteData(ByteData byteData) {
    final Uint8List bytes = byteData.buffer.asUint8List();
    return MapModel(uint8list: bytes);
  }
}

class Maps extends Equatable {
  final Uint8List uint8list;

  const Maps({required this.uint8list});

  @override
  List<Object?> get props => [uint8list];
}
