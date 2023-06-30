import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pollution_environment/model/aqi_current_model.dart';
import 'package:pollution_environment/model/aqi_map_model.dart';
import 'package:pollution_environment/model/area_forest_model.dart';
import 'package:pollution_environment/model/base_response.dart';
import '../../api_service.dart';

class AreaForestAPIPath {
  static String getAreaForest = "/iqair/area-forest";
  static String getIQAirVNRank = "/iqair";
}

class AreaForestAPI {
  final String kAirVisual = "b6e09f2b-ef9f-47d8-99ec-39805e410057";
  late APIService apiService;

  AreaForestAPI() {
    apiService = APIService();
  }

  Future<List<AreaForestModel>> getAreaForest() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: AreaForestAPIPath.getAreaForest,
      );

      BaseArrayResponse baseResponse;
      baseResponse = BaseArrayResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        List<AreaForestModel> data = <AreaForestModel>[];
        baseResponse.data?.forEach((v) {
          data.add(AreaForestModel.fromJson(v));
        });
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<List<IQAirRankVN>> getRankVN() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: AreaForestAPIPath.getIQAirVNRank,
      );

      BaseArrayResponse baseResponse;
      baseResponse = BaseArrayResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        List<IQAirRankVN> data = <IQAirRankVN>[];
        baseResponse.data?.forEach((v) {
          data.add(IQAirRankVN.fromJson(v));
        });
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<AQIMapResponse> getAQIMap(double zoomLevel) async {
    Response response;
    try {
      response = await Dio(BaseOptions(
              baseUrl: "https://website-api.airvisual.com/v1",
              connectTimeout: 8000,
              receiveTimeout: 8000,
              sendTimeout: 8000))
          .request("/places/map/clusters", queryParameters: {
        "units.temperature": "celsius",
        "units.distance": "kilometer",
        "units.pressure": "millibar",
        "AQI": "US",
        "language": "vi",
        "zoomLevel": min(12, zoomLevel),
        "bbox": "102.170435826, 8.1790665, 109.33526981, 23.393395",
      });
      AQIMapResponse aqiMapResponse = AQIMapResponse.fromJson(response.data);
      return aqiMapResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<AQICurentResponse> getAQIByIP() async {
    Response response;
    try {
      response = await Dio(BaseOptions(
              baseUrl: "http://api.airvisual.com/v2",
              connectTimeout: 8000,
              receiveTimeout: 8000,
              sendTimeout: 8000))
          .request("/nearest_city", queryParameters: {
        "key": kAirVisual,
      });
      AQICurentResponse aqiCurentResponse =
          AQICurentResponse.fromJson(response.data);
      return aqiCurentResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<AQICurentResponse> getAQIByGPS(double lat, double lng) async {
    Response response;
    try {
      response = await Dio(BaseOptions(
              baseUrl: "http://api.airvisual.com/v2",
              connectTimeout: 8000,
              receiveTimeout: 8000,
              sendTimeout: 8000))
          .request("/nearest_city",
              queryParameters: {"key": kAirVisual, "lat": lat, "lon": lng});
      AQICurentResponse aqiCurentResponse =
          AQICurentResponse.fromJson(response.data);
      return aqiCurentResponse;
    } on DioError {
      rethrow;
    }
  }
}
