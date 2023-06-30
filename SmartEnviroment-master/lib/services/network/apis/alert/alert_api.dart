import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pollution_environment/model/alert_model.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/notification_alert_model.dart';
import '../../api_service.dart';

class AlertAPIPath {
  static String path = "/alert";
}

class AlertApi {
  late APIService apiService;

  AlertApi() {
    apiService = APIService();
  }

  Future<AlertResponse> getAlerts({int page = 1, int limit = 10}) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: AlertAPIPath.path,
        data: {
          "page": page,
          "limit": limit,
          "type": "create",
          "sortBy": "-updatedAt"
        },
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        AlertResponse data = AlertResponse.fromJson(baseResponse.data!);
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<NotificationAlertResponse> getReceivedAlerts(
      {int page = 1, int limit = 10}) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: AlertAPIPath.path,
        data: {"page": page, "limit": limit, "sortBy": "-updatedAt"},
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        NotificationAlertResponse data =
            NotificationAlertResponse.fromJson(baseResponse.data!);
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> createAlert(
      {required String title,
      required String content,
      required List<String> provinceIds,
      List<File>? files,
      Function(int, int)? onSendProgress}) async {
    Response response;
    Map<String, dynamic> data = {
      "title": title,
      "content": content,
    };

    if (provinceIds.isNotEmpty) {
      for (var i = 0; i < provinceIds.length; i++) {
        data["provinceIds[$i]"] = provinceIds[i];
      }
    }

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
          endPoint: AlertAPIPath.path,
          data: formData,
          onSendProgress: onSendProgress,
          method: APIMethod.POST);

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deleteAllReceivedNotification() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.DELETE,
        endPoint: AlertAPIPath.path,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deleteAlertNotificationById({required String id}) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.DELETE,
        endPoint: "${AlertAPIPath.path}/$id",
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);

      return baseResponse;
    } on DioError {
      rethrow;
    }
  }
}
