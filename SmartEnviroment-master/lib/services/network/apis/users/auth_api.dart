import 'dart:async';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:dio/dio.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/token_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/services/commons/background_location/location_service_repository.dart';
import '../../api_service.dart';

class AuthAPIPath {
  static String login = "/auth/login";
  static String register = "/auth/register";
  static String refreshToken = "/auth/refresh-tokens";
  static String logout = "/auth/logout";
  static String forgotPassword = "/auth/forgot-password";
  static String resetPassword = "/auth/reset-password";
}

class AuthApi {
  late APIService apiService;

  AuthApi() {
    apiService = APIService();
  }

  Future<AuthResponse> login(String email, String password) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: AuthAPIPath.login,
          data: {"email": email, "password": password},
          options: Options(headers: {"requiresToken": false, "isLogin": true}));

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        // Login khong thanh cong
        throw Exception(baseResponse.message);
      } else {
        AuthResponse authResponse = AuthResponse.fromJson(baseResponse.data!);
        return authResponse;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> register(
      String name, String email, String password) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: AuthAPIPath.register,
          data: {"name": name, "email": email, "password": password},
          options: Options(headers: {"requiresToken": false}));

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        // Login khong thanh cong
        throw Exception(baseResponse.message);
      } else {
        AuthResponse authResponse = AuthResponse.fromJson(baseResponse.data!);
        return authResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<TokensResponse> refreshToken(String token) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: AuthAPIPath.refreshToken,
          data: {"refreshToken": token},
          options: Options(headers: {"requiresToken": false}));

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        TokensResponse tokenResponse =
            TokensResponse.fromJson(baseResponse.data!["tokens"]);
        return tokenResponse;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> logout() async {
    Response response;
    try {
      AuthResponse? auth = UserStore().getAuth();
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: AuthAPIPath.logout,
          data: {
            "refreshToken": auth?.tokens?.refresh?.token,
          },
          options: Options(headers: {"requiresToken": false}));

      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> forgotPassword(String email) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: AuthAPIPath.forgotPassword,
          data: {
            "email": email,
          },
          options: Options(headers: {"requiresToken": false}));

      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  Future<BaseResponse> resetPassword(String password, String token) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.POST,
          endPoint: "${AuthAPIPath.resetPassword}?token=$token",
          data: {
            "password": password,
          },
          options: Options(headers: {"requiresToken": false}));

      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    } on DioError {
      rethrow;
    }
  }

  void clearUserData() async {
    await UserStore().removeAuth();
    IsolateNameServer.removePortNameMapping(
        LocationServiceRepository.isolateName);
    await BackgroundLocator.unRegisterLocationUpdate();
  }
}
