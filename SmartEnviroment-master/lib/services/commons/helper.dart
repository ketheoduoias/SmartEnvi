import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

import '../../views/components/custom_dialog.dart';
import 'generated/assets.dart';

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  if (kDebugMode) {
    print('--- Parse json from: $assetsPath');
  }
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  ByteData bytes = await rootBundle.load(imagePath);

  Uint8List imageBytes = bytes.buffer.asUint8List();

  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromList(imageBytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Color getQualityColor(int? quality) {
  switch (quality) {
    case 6:
      return Colors.green;
    case 5:
      return Colors.yellow;
    case 4:
      return Colors.orange;
    case 3:
      return Colors.red;
    case 2:
      return Colors.purple;
    case 1:
      return const Color.fromARGB(255, 128, 0, 0);
    default:
      return Colors.grey;
  }
}

String getQualityText(int? quality) {
  switch (quality) {
    case 6:
      return "Tốt";
    case 5:
      return "Trung bình";
    case 4:
      return "Kém";
    case 3:
      return "Xấu";
    case 2:
      return "Rất xấu";
    case 1:
      return "Nguy hại";
    default:
      return "";
  }
}

String getQualityAQIText(int? quality) {
  switch (quality) {
    case 6:
      return "Tốt";
    case 5:
      return "Trung bình";
    case 4:
      return "Không tốt cho người nhạy cảm";
    case 3:
      return "Có hại cho sức khỏe";
    case 2:
      return "Rất có hại cho sức khỏe";
    case 1:
      return "Nguy hiểm";
    default:
      return "";
  }
}

String getAqiFromQuality(int? quality) {
  switch (quality) {
    case 6:
      return "0 - 50";
    case 5:
      return "51 - 100";
    case 4:
      return "101 - 150";
    case 3:
      return "151 - 200";
    case 2:
      return "201 - 300";
    case 1:
      return "300+";
    default:
      return "";
  }
}

String getAssetPollution(String? pollution) {
  switch (pollution) {
    case "air":
      return Assets.iconPinAir;
    case "land":
      return Assets.iconPinLand;
    case "sound":
      return Assets.iconPinSound;
    case "water":
      return Assets.iconPinWater;
    default:
      return Assets.iconLogo;
  }
}

String getAssetAQI(int? quality) {
  switch (quality) {
    case 1:
      return Assets.iconAQI1;
    case 2:
      return Assets.iconAQI2;
    case 3:
      return Assets.iconAQI3;
    case 4:
      return Assets.iconAQI4;
    case 5:
      return Assets.iconAQI5;
    case 6:
      return Assets.iconAQI6;
    default:
      return Assets.iconAQI6;
  }
}

String getAssetBgAir(int? quality) {
  switch (quality) {
    case 1:
      return Assets.hazardousAirBgCard;
    case 2:
      return Assets.severeAirBgCard;
    case 3:
      return Assets.unhealthyAirBgCard;
    case 4:
      return Assets.poorAirBgCard;
    case 5:
      return Assets.moderateAirBgCard;
    case 6:
      return Assets.goodAirBgCard;
    default:
      return Assets.goodAirBgCard;
  }
}

String getNamePollution(String? pollution) {
  switch (pollution) {
    case "air":
      return "Ô nhiễm không khí";
    case "land":
      return "Ô nhiễm đất";
    case "sound":
      return "Ô nhiễm tiếng ồn";
    case "water":
      return "Ô nhiễm nước";
    default:
      return "";
  }
}

String getShortNamePollution(String? pollution) {
  switch (pollution) {
    case "air":
      return "Không khí";
    case "land":
      return "Đất";
    case "sound":
      return "Tiếng ồn";
    case "water":
      return "Nước";
    default:
      return "";
  }
}

void showAlert({
  String title = "Thông báo",
  required String desc,
  Function? onConfirm,
  String? textConfirm,
  String? textCancel,
  Function? onCancel,
}) {
  Get.generalDialog(
    pageBuilder: (ctx, ani1, ani2) {
      return CustomDialog(
        key: ValueKey("alert"),
        title: title,
        content: desc,
        confirmText: textConfirm,
        cancelText: textCancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
            opacity: a1.value,
            child: CustomDialog(
              title: title,
              content: desc,
              confirmText: textConfirm,
              cancelText: textCancel,
              onConfirm: onConfirm,
              onCancel: onCancel,
            )),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
  );
}

void showLoading({String? text, double? progress}) {
  if (progress != null) {
    EasyLoading.showProgress(progress, status: text);
  } else {
    EasyLoading.show(status: text);
  }
}

void hideLoading() {
  EasyLoading.dismiss();
}

String? convertDate(String date) {
  try {
    var inputDate = DateTime.parse(date);
    var outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  } catch (e) {
    return "";
  }
}

String? convertDateFormat(String date, String format) {
  try {
    var inputDate = DateTime.parse(date);
    var outputFormat = DateFormat(format);
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  } catch (e) {
    return "";
  }
}

String timeAgoSinceDate({bool numericDates = true, required String dateStr}) {
  DateTime? date = DateTime.tryParse(dateStr)?.toLocal();
  if (date == null) return "";
  final date2 = DateTime.now().toLocal();
  final difference = date2.difference(date);

  if (difference.inSeconds < 5) {
    return 'Vừa xong';
  } else if (difference.inSeconds <= 60) {
    return '${difference.inSeconds} giây trước';
  } else if (difference.inMinutes <= 1) {
    return (numericDates) ? '1 phút trước' : 'Một phút trước';
  } else if (difference.inMinutes <= 60) {
    return '${difference.inMinutes} phút trước';
  } else if (difference.inHours <= 1) {
    return (numericDates) ? '1 giờ trước' : 'Một giờ trước';
  } else if (difference.inHours <= 60) {
    return '${difference.inHours} giờ trước';
  } else if (difference.inDays <= 1) {
    return (numericDates) ? '1 ngày trước' : 'Hôm qua';
  } else if (difference.inDays <= 6) {
    return '${difference.inDays} ngày trước';
  } else if ((difference.inDays / 7).ceil() <= 1) {
    return (numericDates) ? '1 tuần trước' : 'Tuần trước';
  } else if ((difference.inDays / 7).ceil() <= 4) {
    return '${(difference.inDays / 7).ceil()} tuần trước';
  } else if ((difference.inDays / 30).ceil() <= 1) {
    return (numericDates) ? '1 tháng trước' : 'Tháng trước';
  } else if ((difference.inDays / 30).ceil() <= 30) {
    return '${(difference.inDays / 30).ceil()} tháng trước';
  } else if ((difference.inDays / 365).ceil() <= 1) {
    return (numericDates) ? '1 năm trước' : 'Năm trước';
  }
  return '${(difference.inDays / 365).floor()} năm trước';
}

Future<String> getDeviceIdentifier() async {
  String deviceIdentifier = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (kIsWeb) {
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
    deviceIdentifier =
        "${webInfo.vendor}${webInfo.userAgent}${webInfo.hardwareConcurrency.toString()}";
  } else {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.androidId ?? "";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor ?? "";
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceIdentifier = linuxInfo.machineId ?? "";
    }
  }
  return deviceIdentifier;
}

Color getColorRank(int? rank) {
  if (rank == null) return Colors.grey;
  if (rank <= 10) {
    return Colors.green;
  } else if (rank <= 20) {
    return Colors.cyan;
  } else if (rank <= 50) {
    return Colors.yellow;
  } else if (rank <= 100) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

Color getTextColorRank(int? quality) {
  if (quality == null) return Colors.white;
  if (quality >= 5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

int? getAQIRank(double? aqi) {
  if (aqi == null) return null;
  if (aqi >= 0 && aqi <= 50) return 6;
  if (aqi >= 51 && aqi <= 100) return 5;
  if (aqi >= 101 && aqi <= 150) return 4;
  if (aqi >= 151 && aqi <= 200) return 3;
  if (aqi >= 201 && aqi <= 300) return 2;
  if (aqi >= 301) return 1;
  return 6;
}
