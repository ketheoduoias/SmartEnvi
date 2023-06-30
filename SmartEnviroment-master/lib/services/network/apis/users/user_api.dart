import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import '../../api_service.dart';

class UserAPIPath {
  static String getUserById = "/users";
  static String getAllUser = "/users";
  static String deleteUser = '/users';
}

class UserAPI {
  late APIService apiService;

  UserAPI() {
    apiService = APIService();
  }
  Future<UserListResponse> getAllUser(
      {int? page, int? limit, String? searchText}) async {
    Response response;
    Map<String, String> data = {};
    if (limit != null) data["limit"] = '$limit';
    if (page != null) data["page"] = '$page';
    if (searchText != null && searchText.isNotEmpty) {
      data["search"] = searchText;
    }
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: UserAPIPath.getAllUser,
        data: data,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        UserListResponse listResponse =
            UserListResponse.fromJson(baseResponse.data!);
        return listResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<UserModel> getUserById(String id) async {
    Response response;
    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: "${UserAPIPath.getUserById}/$id",
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        UserModel userModel = UserModel.fromJson(baseResponse.data!);
        return userModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<UserModel> updateNotificationReceived(
      {required String id, required bool isReceived}) async {
    Response response;
    Map<String, dynamic> data = {};
    data["isNotificationReceived"] = isReceived;

    FormData formData = FormData.fromMap(data);

    try {
      response = await apiService.requestFormData(
        endPoint: "${UserAPIPath.getUserById}/$id",
        data: formData,
        method: APIMethod.PATCH,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        UserModel userModel = UserModel.fromJson(baseResponse.data!);
        return userModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<UserModel> updateLocation(
      {required String id, required double lat, required double lng}) async {
    Response response;
    Map<String, dynamic> data = {};
    data["lat"] = lat;
    data["lng"] = lng;

    try {
      response = await apiService.request(
        endPoint: "${UserAPIPath.getUserById}/$id",
        data: data,
        options: Options(headers: {"requiresToken": false}),
        method: APIMethod.PUT,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        UserModel userModel = UserModel.fromJson(baseResponse.data!);
        return userModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<UserModel> updateUser(
      {required String id,
      String? name,
      String? email,
      String? password,
      double? lat,
      double? lng,
      String? role,
      List<String>? provinceManage,
      File? avatar}) async {
    Response response;
    Map<String, dynamic> data = {};
    if (name != null) data["name"] = name;
    if (email != null) data["email"] = email;
    if (password != null) data["password"] = password;
    if (lat != null) data["lat"] = lat;
    if (lng != null) data["lng"] = lng;
    if (role != null) data["role"] = role;
    if (provinceManage != null) {
      for (int i = 0; i < provinceManage.length; i++) {
        data["provinceManage[$i]"] = provinceManage[i];
      }
    }
    if (avatar != null) {
      var pic = MultipartFile.fromFileSync(
        avatar.path,
        filename: avatar.uri.toString(),
      );
      data["image"] = pic;
    }

    FormData formData = FormData.fromMap(data);

    try {
      response = await apiService.requestFormData(
        endPoint: "${UserAPIPath.getUserById}/$id",
        data: formData,
        method: APIMethod.PATCH,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        UserModel userModel = UserModel.fromJson(baseResponse.data!);
        return userModel;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> deleteUser({required String id}) async {
    Response response;

    try {
      response = await apiService.request(
        endPoint: "${UserAPIPath.deleteUser}/$id",
        method: APIMethod.DELETE,
      );

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);

      return baseResponse;
    } on DioError {
      rethrow;
    }
  }
}
