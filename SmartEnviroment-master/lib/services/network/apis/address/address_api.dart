import 'package:dio/dio.dart';
import 'package:pollution_environment/model/address_model.dart';

import '../../api_service.dart';

class AddressAPIPath {
  static String getAddress = "/address";
  static String parseAddress = "/address/parse";
}

class AddressApi {
  late APIService apiService;

  AddressApi() {
    apiService = APIService();
  }

  Future<AddressModel> getAllAddress() async {
    Response response;

    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: AddressAPIPath.getAddress,
      );
      AddressModel data = AddressModel.fromJson(response.data!);
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future<ProvinceModel> getAddressById(String id) async {
    Response response;

    try {
      response = await apiService.request(
        method: APIMethod.GET,
        endPoint: "${AddressAPIPath.getAddress}/$id",
      );
      ProvinceModel data = ProvinceModel.fromJson(response.data!);
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future<ParseAddressResponse> parseAddress(double lat, double lng) async {
    Response response;

    try {
      response = await apiService.request(
          method: APIMethod.GET,
          endPoint: AddressAPIPath.parseAddress,
          data: {"lat": lat, "lng": lng});
      ParseAddressResponse data = ParseAddressResponse.fromJson(response.data);
      return data;
    } on DioError {
      rethrow;
    }
  }
}
