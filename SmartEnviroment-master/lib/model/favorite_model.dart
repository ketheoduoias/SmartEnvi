import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 1)
class Favorite {
  @HiveField(0)
  String province;

  @HiveField(1)
  String district;

  @HiveField(2)
  String ward;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lng;

  Favorite({
    required this.province,
    required this.district,
    required this.ward,
    required this.lat,
    required this.lng,
  });
}
