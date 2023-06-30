import 'package:dio/dio.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/notification_model.dart';
import '../../../commons/helper.dart';
import '../../api_service.dart';

class NotificationAPIPath {
  static String getNotification = "/notification";
  static String updateFCMToken = "/fcm-token";
}

class NotificationApi {
  late APIService apiService;

  NotificationApi() {
    apiService = APIService();
  }

  Future<BaseResponse> updateFCMToken(String token) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.POST,
        endPoint: NotificationAPIPath.updateFCMToken,
        data: {
          "token": token,
          "deviceId": await getDeviceIdentifier(),
        },
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<NotificationResponse> getNotifications({int page = 1}) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.GET,
          endPoint: NotificationAPIPath.getNotification,
          data: {"page": page, "sortBy": "-updatedAt"});

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        NotificationResponse data =
            NotificationResponse.fromJson(baseResponse.data!);
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deleteAllNotification() async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.DELETE,
        endPoint: NotificationAPIPath.getNotification,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deleteNotificationById({required String id}) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.DELETE,
        endPoint: "${NotificationAPIPath.getNotification}/$id",
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);

      return baseResponse;
    } on DioError {
      rethrow;
    }
  }
}
