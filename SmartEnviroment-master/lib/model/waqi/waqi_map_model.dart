import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WAQIMapResponse {
  String? status;
  List<WAQIMapData>? data;

  WAQIMapResponse({this.status, this.data});

  WAQIMapResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <WAQIMapData>[];
      json['data'].forEach((v) {
        data!.add(WAQIMapData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WAQIMapData with ClusterItem {
  double? lat;
  double? lon;
  int? uid;
  String? aqi;
  WAQIMapStation? station;

  WAQIMapData({this.lat, this.lon, this.uid, this.aqi, this.station});

  WAQIMapData.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    uid = json['uid'];
    aqi = json['aqi'];
    station = json['station'] != null
        ? WAQIMapStation.fromJson(json['station'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['uid'] = uid;
    data['aqi'] = aqi;
    if (station != null) {
      data['station'] = station!.toJson();
    }
    return data;
  }

  @override
  LatLng get location => LatLng(lat ?? 0, lon ?? 0);
}

class WAQIMapStation {
  String? name;
  String? time;

  WAQIMapStation({this.name, this.time});

  WAQIMapStation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['time'] = time;
    return data;
  }
}
