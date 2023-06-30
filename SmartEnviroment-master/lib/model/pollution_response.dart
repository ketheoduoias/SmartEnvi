import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PollutionModel with ClusterItem {
  List<String>? images;
  int? qualityScore;
  String? provinceName;
  String? provinceId;
  String? districtName;
  String? districtId;
  String? wardName;
  String? wardId;
  String? type;
  String? quality;
  String? user;
  String? desc;
  String? specialAddress;
  double? lat;
  double? lng;
  String? createdAt;
  String? updatedAt;
  String? id;
  int? status;

  PollutionModel(
      {this.images,
      this.qualityScore,
      this.provinceName,
      this.provinceId,
      this.districtName,
      this.districtId,
      this.wardName,
      this.wardId,
      this.type,
      this.quality,
      this.user,
      this.desc,
      this.specialAddress,
      this.lat,
      this.lng,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.id});

  PollutionModel.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    qualityScore = json['qualityScore'];
    provinceName = json['provinceName'];
    provinceId = json['provinceId'];
    districtName = json['districtName'];
    districtId = json['districtId'];
    wardName = json['wardName'];
    wardId = json['wardId'];
    type = json['type'];
    quality = json['quality'];
    user = json['user'];
    desc = json['desc'];
    specialAddress = json['specialAddress'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    data['qualityScore'] = qualityScore;
    data['provinceName'] = provinceName;
    data['provinceId'] = provinceId;
    data['districtName'] = districtName;
    data['districtId'] = districtId;
    data['wardName'] = wardName;
    data['wardId'] = wardId;
    data['type'] = type;
    data['quality'] = quality;
    data['user'] = user;
    data['desc'] = desc;
    data['specialAddress'] = specialAddress;
    data['lat'] = lat;
    data['lng'] = lng;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['status'] = status;
    return data;
  }

  @override
  LatLng get location => LatLng(lat ?? 0, lng ?? 0);
}

class PollutionsResponse {
  List<PollutionModel>? results;
  int? page;
  int? limit;
  int? totalPages;
  int? totalResults;
  num? avgQualityScore;
  String? avgQuality;

  PollutionsResponse(
      {this.results,
      this.page,
      this.limit,
      this.totalPages,
      this.totalResults,
      this.avgQualityScore,
      this.avgQuality});

  PollutionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <PollutionModel>[];
      json['results'].forEach((v) {
        results!.add(PollutionModel.fromJson(v));
      });
    }
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    totalResults = json['totalResults'];
    avgQualityScore = json['avgQualityScore'];
    avgQuality = json['avgQuality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['totalResults'] = totalResults;
    data['avgQualityScore'] = avgQualityScore;
    data['avgQuality'] = avgQuality;
    return data;
  }
}
