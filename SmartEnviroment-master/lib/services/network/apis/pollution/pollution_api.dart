import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/pollution_quality_model.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/pollution_stats.dart';
import 'package:pollution_environment/model/pollution_type_model.dart';
import '../../api_service.dart';

class PollutionAPIPath {
  static String getPollutionTypes = "/pollutions/types";
  static String getPollutionQualities = "/pollutions/qualities";
  static String getPollutionAuth = '/pollutions/me';
  static String getPollution = "/pollutions";
  static String updatePollution = "/pollutions";
  static String deletePollution = "/pollutions";
  static String getPollutionStats = "/pollutions/stats";
  static String getPollutionHistory = "/pollutions/history";
  static String getPollutionByUser = "/pollutions/user";
}

class PollutionApi {
  late APIService apiService;

  PollutionApi() {
    apiService = APIService();
  }

  Future<List<PollutionType>> getPollutionTypes() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: PollutionAPIPath.getPollutionTypes,
      );

      BaseArrayResponse baseResponse;
      baseResponse = BaseArrayResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        List<PollutionType> data = <PollutionType>[];
        baseResponse.data?.forEach((v) {
          data.add(PollutionType.fromJson(v));
        });
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<List<PollutionQuality>> getPollutionQualities() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: PollutionAPIPath.getPollutionQualities,
      );

      BaseArrayResponse baseResponse;
      baseResponse = BaseArrayResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        List<PollutionQuality> data = <PollutionQuality>[];
        baseResponse.data?.forEach((v) {
          data.add(PollutionQuality.fromJson(v));
        });
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionsResponse> getAllPollution(
      {List<String>? type,
      String? provinceName,
      String? districtName,
      String? wardName,
      List<String>? provinceIds,
      List<String>? districtIds,
      List<String>? wardIds,
      int? status,
      List<String>? quality,
      String? searchText,
      String? userId,
      int? limit,
      String? startDate,
      String? endDate,
      int? page}) async {
    Response response;
    Map<String, String> data = {};

    if (type != null) {
      if (type.isNotEmpty) {
        for (int i = 0; i < type.length; i++) {
          data["type[$i]"] = type[i];
        }
      } else {
        data["type[0]"] = "";
      }
    }
    if (provinceIds != null && provinceIds.isNotEmpty) {
      for (int i = 0; i < provinceIds.length; i++) {
        data["provinceId[$i]"] = provinceIds[i];
      }
    }

    if (districtIds != null && districtIds.isNotEmpty) {
      for (int i = 0; i < districtIds.length; i++) {
        data["districtId[$i]"] = districtIds[i];
      }
    }

    if (wardIds != null && wardIds.isNotEmpty) {
      for (int i = 0; i < wardIds.length; i++) {
        data["wardId[$i]"] = wardIds[i];
      }
    }

    if (provinceName != null && provinceName != '') {
      data["provinceName"] = provinceName;
    }
    if (districtName != null && districtName != '') {
      data["districtName"] = districtName;
    }
    if (quality != null) {
      if (quality.isNotEmpty) {
        for (int i = 0; i < quality.length; i++) {
          data["quality[$i]"] = quality[i];
        }
      } else {
        data["quality[0]"] = "";
      }
    }
    if (status != null) data["status"] = '$status';
    if (userId != null && userId != '') data["userId"] = userId;
    if (limit != null) data["limit"] = '$limit';
    if (page != null) data["page"] = '$page';
    if (startDate != null) data['startDate'] = startDate;
    if (endDate != null) data['endDate'] = endDate;

    if (searchText != null && searchText.isNotEmpty) {
      data["search"] = searchText;
    }
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: PollutionAPIPath.getPollution,
        data: data,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionsResponse pollutionsResponse =
            PollutionsResponse.fromJson(baseResponse.data!);
        return pollutionsResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionsResponse> getPollutionAuth(
      {List<String>? type,
      String? provinceName,
      String? districtName,
      String? wardName,
      int? status,
      List<String>? quality,
      int? limit,
      String? sortBy,
      int? page}) async {
    Response response;
    Map<String, String> data = {};

    if (type != null && type.isNotEmpty) {
      for (int i = 0; i < type.length; i++) {
        data["type[$i]"] = type[i];
      }
    }
    if (provinceName != null && provinceName != '') {
      data["provinceName"] = provinceName;
    }
    if (districtName != null && districtName != '') {
      data["districtName"] = districtName;
    }
    if (quality != null && quality.isNotEmpty) {
      for (int i = 0; i < quality.length; i++) {
        data["quality[$i]"] = quality[i];
      }
    }
    if (status != null) data["status"] = '$status';
    if (limit != null) data["limit"] = '$limit';
    if (page != null) data["page"] = '$page';
    if (sortBy != null) data["sortBy"] = sortBy;

    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: PollutionAPIPath.getPollutionAuth,
        data: data,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionsResponse pollutionsResponse =
            PollutionsResponse.fromJson(baseResponse.data!);
        return pollutionsResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionsResponse> getPollutionByUser(
      {required String userId, int? limit, String? sortBy, int? page}) async {
    Response response;
    Map<String, String> data = {};

    data["user"] = userId;
    if (limit != null) data["limit"] = '$limit';
    if (page != null) data["page"] = '$page';
    if (sortBy != null) data["sortBy"] = sortBy;

    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: PollutionAPIPath.getPollutionByUser,
        data: data,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionsResponse pollutionsResponse =
            PollutionsResponse.fromJson(baseResponse.data!);
        return pollutionsResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionModel> getOnePollution({required String id}) async {
    Response response;

    try {
      response = await apiService.request(
          endPoint: "${PollutionAPIPath.getPollution}/$id",
          method: APIMethod.GET);

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionModel pollutionModel =
            PollutionModel.fromJson(baseResponse.data!);
        return pollutionModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionModel> createPollution(
      {required String type,
      required String provinceName,
      required String provinceId,
      required String districtId,
      required String districtName,
      required String wardName,
      required String wardId,
      required String quality,
      required String desc,
      required String specialAddress,
      double? lat,
      double? lng,
      List<File>? files,
      Function(int, int)? onSendProgress}) async {
    Response response;
    Map<String, dynamic> data = {
      "type": type,
      "provinceName": provinceName,
      "provinceId": provinceId,
      "districtName": districtName,
      "districtId": districtId,
      "wardName": wardName,
      "wardId": wardId,
      "quality": quality,
      "desc": desc,
      "specialAddress": specialAddress
    };

    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;

    if (files != null) {
      List<MultipartFile> multipartImageList = [];
      for (var i = 0; i < files.length; i++) {
        var pic = MultipartFile.fromFileSync(
          files[i].path,
          filename: files[i].uri.toString(),
        );
        multipartImageList.add(pic);
      }
      if (multipartImageList.isNotEmpty) {
        data["images"] = multipartImageList;
      }
    }

    FormData formData = FormData.fromMap(data);

    try {
      response = await apiService.requestFormData(
          endPoint: PollutionAPIPath.updatePollution,
          data: formData,
          onSendProgress: onSendProgress,
          method: APIMethod.POST);

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionModel pollutionModel =
            PollutionModel.fromJson(baseResponse.data!);
        return pollutionModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deletePollution({required String id}) async {
    Response response;

    try {
      response = await apiService.request(
        endPoint: "${PollutionAPIPath.deletePollution}/$id",
        method: APIMethod.DELETE,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);

      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionModel> updatePollution(
      {required String id,
      String? type,
      String? provinceName,
      String? provinceId,
      String? districtId,
      String? districtName,
      String? wardName,
      String? wardId,
      String? quality,
      String? desc,
      String? specialAddress,
      int? status,
      double? lat,
      double? lng,
      List<File>? files,
      Function(int, int)? onSendProgress}) async {
    Response response;
    Map<String, dynamic> data = {};
    if (status != null) data['status'] = status;
    if (type != null) data['type'] = type;
    if (provinceName != null) data['provinceName'] = provinceName;
    if (provinceId != null) data['provinceId'] = provinceId;
    if (districtName != null) data['districtName'] = districtName;
    if (districtId != null) data['districtId'] = districtId;
    if (wardName != null) data['wardName'] = wardName;
    if (wardId != null) data['wardId'] = wardId;

    if (quality != null) data['quality'] = quality;
    if (desc != null) data['desc'] = desc;
    if (specialAddress != null) data['specialAddress'] = specialAddress;

    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;

    if (files != null) {
      List<MultipartFile> multipartImageList = [];
      for (var i = 0; i < files.length; i++) {
        var pic = MultipartFile.fromFileSync(
          files[i].path,
          filename: files[i].uri.toString(),
        );
        multipartImageList.add(pic);
      }
      if (multipartImageList.isNotEmpty) {
        data["images"] = multipartImageList;
      }
    }

    FormData formData = FormData.fromMap(data);

    try {
      response = await apiService.requestFormData(
          endPoint: "${PollutionAPIPath.updatePollution}/$id",
          data: formData,
          onSendProgress: onSendProgress,
          method: APIMethod.PATCH);

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionModel pollutionModel =
            PollutionModel.fromJson(baseResponse.data!);
        return pollutionModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<PollutionStats> getPollutionStats() async {
    Response response;

    try {
      response = await apiService.request(
          endPoint: PollutionAPIPath.getPollutionStats, method: APIMethod.GET);

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        PollutionStats pollutionStats =
            PollutionStats.fromJson(baseResponse.data!);
        return pollutionStats;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<List<PollutionModel>> getPollutionHistory(String? districtId) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.GET,
          endPoint: PollutionAPIPath.getPollutionHistory,
          data: {"districtId": districtId ?? ""});
      BaseArrayResponse baseArrayResponse;
      baseArrayResponse = BaseArrayResponse.fromJson(response.data);
      if (baseArrayResponse.data == null) {
        throw Exception(baseArrayResponse.message);
      } else {
        List<PollutionModel> data = [];
        baseArrayResponse.data?.forEach((element) {
          data.add(PollutionModel.fromJson(element));
        });
        return data;
      }
    } on DioError {
      rethrow;
    }
  }
}
