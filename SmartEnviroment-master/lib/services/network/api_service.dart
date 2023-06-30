// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getx;
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/token_response.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../commons/helper.dart';
import 'apis/users/auth_api.dart';

enum APIMethod { GET, POST, PUT, PATCH, DELETE }

// final host = "https://smartenvironment.up.railway.app";
// final host = "http://192.168.123.235:3000";
// final host = "http://172.16.133.35:3000";
const host = "https://www.hungs20.xyz";
const baseUrl = "$host/v1";

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers["requiresToken"] == false) {
      // if the request doesn't need token, then just continue to the next interceptor
      options.headers.remove("requiresToken"); //remove the auxiliary header
      return handler.next(options);
    }

    // get tokens from local storage
    AuthResponse? currentAuth = UserStore().getAuth();
    String? accessToken = currentAuth?.tokens?.access?.token;
    String? refreshToken = currentAuth?.tokens?.refresh?.token;

    if (accessToken == null || refreshToken == null) {
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = "TokenNotFound";
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }

    // check if tokens have already expired or not
    // I use jwt_decoder package
    // Note: ensure your tokens has "exp" claim
    final accessTokenHasExpired = JwtDecoder.isExpired(accessToken);
    final refreshTokenHasExpired = JwtDecoder.isExpired(refreshToken);

    var _refreshed = true;

    if (refreshTokenHasExpired) {
      _performLogout(_dio);

      // create custom dio error
      options.extra["tokenErrorType"] = "RefreshTokenHasExpired";
      final error = DioError(requestOptions: options, type: DioErrorType.other);

      return handler.reject(error);
    } else if (accessTokenHasExpired) {
      // regenerate access token
      _refreshed = await _regenerateAccessToken();
    }

    if (_refreshed) {
      // add access token to the request header
      AuthResponse? newAuth = UserStore().getAuth();
      String? newAccessToken = newAuth?.tokens?.access?.token;
      options.headers["Authorization"] = "Bearer $newAccessToken";
      return handler.next(options);
    } else {
      // create custom dio error
      options.extra["tokenErrorType"] = "FailedToRegenerateAccessToken";
      final error = DioError(requestOptions: options, type: DioErrorType.other);
      return handler.reject(error);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      // for some reasons the token can be invalidated before it is expired by the backend.
      // then we should navigate the user back to login page
      if (err.requestOptions.headers["isLogin"] == true) {
        // Không xử lý lỗi token khi đăng nhập
        return handler.next(err);
      }
      _performLogout(_dio);

      // create custom dio error
      err.type = DioErrorType.other;
      err.requestOptions.extra["tokenErrorType"] = "InvalidAccessToken";
    }

    return handler.next(err);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      print(response.data);
    }
    return handler.next(response);
  }

  void _performLogout(Dio dio) async {
    await UserStore().removeAuth(); // remove token from local storage
    // back to login page without using context
    Fluttertoast.showToast(
        msg: "Phiên làm việc đã hết hạn, vui lòng đăng nhập lại");
    getx.Get.offAllNamed(Routes.LOGIN_SCREEN);
  }

  /// return true if it is successfully regenerate the access token
  Future<bool> _regenerateAccessToken() async {
    try {
      var dio =
          Dio(); // should create new dio instance because the request interceptor is being locked

      // get refresh token from local storage
      AuthResponse? currentAuth = UserStore().getAuth();
      final refreshToken = currentAuth?.tokens?.refresh?.token;

      // make request to server to get the new access token from server using refresh token
      final response = await dio.post(
        "$baseUrl${AuthAPIPath.refreshToken}",
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        BaseResponse baseResponse;
        baseResponse = BaseResponse.fromJson(response.data);
        if (baseResponse.data == null) {
          _performLogout(_dio);
          return false;
        } else {
          TokensResponse tokenResponse =
              TokensResponse.fromJson(baseResponse.data!["tokens"]);
          String? accessToken = tokenResponse.access?.token;
          String? refreshToken = tokenResponse.refresh?.token;
          if (accessToken != null && refreshToken != null) {
            AuthResponse? currentAuth = UserStore().getAuth();
            if (currentAuth != null) {
              currentAuth.tokens = tokenResponse;
              await UserStore().saveAuth(currentAuth);
              return true;
            } else {
              _performLogout(_dio);
              return false;
            }
          } else {
            _performLogout(_dio);
            return false;
          }
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // it means your refresh token no longer valid now, it may be revoked by the backend
        _performLogout(_dio);
        return false;
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        return false;
      }
    } on DioError {
      return false;
    } catch (e) {
      return false;
    }
  }
}

class APIService {
  late Dio _dio;
  static final APIService _singleton = APIService._internal();

  factory APIService() {
    return _singleton;
  }

  APIService._internal();
  void init() {
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 8000,
        receiveTimeout: 8000,
        sendTimeout: 8000));

    _dio.interceptors.addAll([
      AuthInterceptor(_dio), // add this line before LogInterceptor
      LogInterceptor(),
    ]);
  }

  Future<Response> request(
      {required APIMethod method,
      required String endPoint,
      Map<String, dynamic>? data,
      Options? options}) async {
    Response response;

    try {
      switch (method) {
        case APIMethod.POST:
          response = await _dio.post(endPoint, data: data, options: options);
          break;
        case APIMethod.PUT:
          response = await _dio.put(endPoint, data: data, options: options);
          break;
        case APIMethod.PATCH:
          response = await _dio.patch(endPoint, data: data, options: options);
          break;
        case APIMethod.DELETE:
          response = await _dio.delete(endPoint, data: data, options: options);
          break;
        default:
          response =
              await _dio.get(endPoint, queryParameters: data, options: options);
      }
    } on DioError catch (e) {
      BaseResponse? baseResponse;
      if (e.response?.data != null) {
        baseResponse = BaseResponse.fromJson(e.response?.data);
      }
      hideLoading();
      showAlert(desc: baseResponse?.message ?? e.message);
      throw Exception(baseResponse?.message ?? e.message);
    } catch (e) {
      hideLoading();
      showAlert(desc: "Đã có lỗi xảy ra, vui lòng thử lại");
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại.");
    }
    return response;
  }

  Future<Response> requestFormData(
      {required String endPoint,
      required APIMethod method,
      FormData? data,
      Function(int, int)? onSendProgress}) async {
    Response response;

    try {
      switch (method) {
        case APIMethod.POST:
          response = await _dio.post(endPoint,
              data: data,
              options: Options(contentType: "multipart/form-data"),
              onSendProgress: onSendProgress);
          break;
        case APIMethod.PUT:
          response = await _dio.put(endPoint,
              data: data,
              options: Options(contentType: "multipart/form-data"),
              onSendProgress: onSendProgress);
          break;
        case APIMethod.PATCH:
          response = await _dio.patch(endPoint,
              data: data,
              options: Options(contentType: "multipart/form-data"),
              onSendProgress: onSendProgress);
          break;
        case APIMethod.DELETE:
          response = await _dio.delete(
            endPoint,
            data: data,
            options: Options(contentType: "multipart/form-data"),
          );
          break;
        default:
          response = await _dio.post(endPoint,
              data: data,
              options: Options(contentType: "multipart/form-data"),
              onSendProgress: onSendProgress);
      }
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.response:
          BaseResponse baseResponse = BaseResponse.fromJson(e.response?.data);
          throw Exception(baseResponse.message ?? e.message);
        case DioErrorType.connectTimeout:
          throw Exception("Quá thời gian kết nối");
        case DioErrorType.receiveTimeout:
          throw Exception("Quá thời gian chờ");
        case DioErrorType.other:
          throw Exception("Lỗi không xác định\n${e.message}");
        default:
          throw Exception(e.message);
      }
    } catch (e) {
      throw Exception("Đã có lỗi xảy ra, vui lòng thử lại.");
    }
    return response;
  }
}
