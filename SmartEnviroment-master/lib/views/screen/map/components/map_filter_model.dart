import 'package:flutter/material.dart';

enum MapFilterType { layer, marker }

class MapFilterModel {
  String name;
  String value;
  Map colors;
  MapFilterType type;
  MapFilterModel(this.name, this.value, this.colors, this.type);
}

class MapLayerFilterValue {
  static MapFilterModel temperature = MapFilterModel(
    "Nhiệt độ",
    "TA2",
    {
      -65: const Color(0x82169200),
      -55: const Color(0x82169200),
      -45: const Color(0x82169200),
      -40: const Color(0x82169200),
      -30: const Color(0x8257DB00),
      -20: const Color(0x208CEC00),
      -10: const Color(0x20C4E800),
      0: const Color(0x23DDDD00),
      10: const Color(0xC2FF2800),
      20: const Color(0xFFF02800),
      25: const Color(0xFFC22800),
      30: const Color(0xFC801400)
    },
    MapFilterType.layer,
  );

  static MapFilterModel wind = MapFilterModel(
    "Tốc độ gió",
    "WND",
    {
      1: const Color(0xFFFFFF00),
      5: const Color(0xEECECC66),
      15: const Color(0xB364BCB3),
      25: const Color(0x3F213BCC),
      50: const Color(0x744CACE6),
      100: const Color(0x4600AFFF),
      200: const Color(0x0D1126FF),
    },
    MapFilterType.layer,
  );

  static MapFilterModel accumulated = MapFilterModel(
    "Lượng mưa tích lũy",
    "PA0",
    {
      0: const Color(0x00000000),
      0.1: const Color(0xC8969600),
      0.2: const Color(0x9696AA00),
      0.5: const Color(0x7878BE19),
      1: const Color(0x6E6ECD33),
      10: const Color(0x5050E1B2),
      140: const Color(0x1414FFE5),
    },
    MapFilterType.layer,
  );

  static MapFilterModel humidity = MapFilterModel(
    "Độ ẩm",
    "HRD0",
    {
      0: const Color(0x00000000),
      0.1: const Color(0xC8969600),
      0.2: const Color(0x9696AA00),
      0.5: const Color(0x7878BE19),
      1: const Color(0x6E6ECD33),
      10: const Color(0x5050E1B2),
      140: const Color(0x1414FFE5),
    },
    MapFilterType.layer,
  );

  /// Marker
  static MapFilterModel pm25 = MapFilterModel(
    "PM2.5",
    "usepa-pm25",
    {},
    MapFilterType.marker,
  );

  static MapFilterModel pm10 = MapFilterModel(
    "PM10",
    "usepa-10",
    {},
    MapFilterType.marker,
  );

  static MapFilterModel o3 = MapFilterModel(
    "O3",
    "usepa-o3",
    {},
    MapFilterType.marker,
  );
  static MapFilterModel no2 = MapFilterModel(
    "NO2",
    "usepa-no2",
    {},
    MapFilterType.marker,
  );
  static MapFilterModel so2 = MapFilterModel(
    "SO2",
    "usepa-so2",
    {},
    MapFilterType.marker,
  );

  static MapFilterModel co = MapFilterModel(
    "CO",
    "usepa-co",
    {},
    MapFilterType.marker,
  );
}
