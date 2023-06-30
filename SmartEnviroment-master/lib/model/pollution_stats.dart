import 'package:pollution_environment/model/pollution_response.dart';

class PollutionStats {
  int air = 0;
  int land = 0;
  int sound = 0;
  int water = 0;
  int total = 0;
  List<PollutionModel>? weekData;

  PollutionStats.fromJson(Map<String, dynamic> json) {
    air = json['air'];
    land = json['land'];
    sound = json['sound'];
    water = json['water'];
    total = json['total'];
    if (json['weekData'] != null) {
      weekData = <PollutionModel>[];
      json['weekData'].forEach((v) {
        weekData!.add(PollutionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air'] = air;
    data['land'] = land;
    data['sound'] = sound;
    data['water'] = water;
    data['total'] = total;
    if (weekData != null) {
      data['weekData'] = weekData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
