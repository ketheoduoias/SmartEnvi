import '../../api_service.dart';

class WeatherPath {
  static String get = "";
  static String kWeather = "856822fd8e22db5e1ba48c0e7d69844a";
  static String kWeatherEdu = "6db548d642b465e35888b3b59fe17f95";
}

class WeatherAPI {
  late APIService apiService;

  WeatherAPI() {
    apiService = APIService();
  }
}
