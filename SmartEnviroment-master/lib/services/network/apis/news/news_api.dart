import 'package:dio/dio.dart';
import 'package:pollution_environment/model/base_response.dart';
import 'package:pollution_environment/model/facebook_response.dart';
import 'package:pollution_environment/model/news_model.dart';
import '../../api_service.dart';

class NewsAPIPath {
  static String getNews = "/news";
  static String getNewsFB = "/news";
}

class NewsApi {
  late APIService apiService;

  NewsApi() {
    apiService = APIService();
  }

  Future<NewsResponse> getNews(
      {int page = 1, int limit = 10, String? type}) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.GET,
          endPoint: NewsAPIPath.getNews,
          data: {"page": page, "limit": limit, "type": type});

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        NewsResponse data = NewsResponse.fromJson(baseResponse.data!);
        return data;
      }
    } on DioError {
      rethrow;
    }
  }

  Future<FBNewsResponse> getNewsFB({int page = 1, int limit = 10}) async {
    Response response;
    try {
      response = await apiService.request(
          method: APIMethod.GET,
          endPoint: NewsAPIPath.getNewsFB,
          data: {"page": page, "limit": limit, "type": "fb"});

      BaseResponse baseResponse;
      baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.data == null) {
        throw Exception(baseResponse.message);
      } else {
        FBNewsResponse data = FBNewsResponse.fromJson(baseResponse.data!);
        return data;
      }
    } on DioError {
      rethrow;
    }
  }
}
