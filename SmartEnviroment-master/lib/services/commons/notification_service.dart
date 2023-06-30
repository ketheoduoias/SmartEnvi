import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';
import 'package:pollution_environment/services/network/api_service.dart';
import 'package:pollution_environment/views/screen/detail_pollution/detail_pollution_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'helper.dart';

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<void> showNotifications(RemoteMessage message) async {
    final jsonData = json.decode(message.data["data"]);
    if (jsonData["userCreated"] != null) {
      // Thông báo khẩn cấp
    } else {
      PollutionModel pollution = PollutionModel.fromJson(jsonData);
      await showLocalNotificationPollution(pollution, message);
    }
  }

  Future<void> showLocalNotificationPollution(
      PollutionModel pollution, RemoteMessage message) async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl('$host/ic_pin_${pollution.type ?? ""}.png'));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        (pollution.images ?? []).isNotEmpty
            ? await _getByteArrayFromUrl(pollution.images!.first)
            : await _getByteArrayFromUrl(
                '$host/ic_pin_${pollution.type ?? ""}.png'));
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(bigPicture,
            largeIcon: largeIcon,
            contentTitle:
                "Tại ${pollution.specialAddress}, ${pollution.wardName}, ${pollution.districtName}, ${pollution.provinceName}",
            htmlFormatContentTitle: true,
            summaryText: pollution.desc,
            htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('12', 'Thông báo ô nhiễm',
            channelDescription: 'Thông báo thông tin ô nhiễm môi trường',
            vibrationPattern: vibrationPattern,
            priority: Priority.high,
            importance: Importance.high,
            enableLights: true,
            color: const Color.fromARGB(255, 255, 0, 0),
            ledColor: const Color.fromARGB(255, 255, 0, 0),
            ledOnMs: 1000,
            ledOffMs: 500,
            styleInformation: bigPictureStyleInformation);

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, platformChannelSpecifics,
        payload: pollution.id);
  }

  Future showNotificationWithoutSound(Position position) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        '1', 'location-bg',
        channelDescription: 'fetch location in background',
        playSound: false,
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Location fetched',
      position.toString(),
      platformChannelSpecifics,
      payload: '',
    );
  }

  Future showCurrentAQI(WAQIIpResponse aqiCurentResponse) async {
    // final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
    //     await _getByteArrayFromUrl(
    //         'http://openweathermap.org/img/wn/${aqiCurentResponse.data?.current?.weather?.ic ?? ''}@2x.png'));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2',
      'Thông tin thời tiết',
      channelDescription: 'Cập nhật thông tin thời tiết',
      // largeIcon: largeIcon,
      enableVibration: true,
      channelShowBadge: false,
      priority: Priority.high,
      importance: Importance.max,
      color: Color.fromARGB(255, 0, 255, 0),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Dự báo từ · ${aqiCurentResponse.data?.city?.name ?? ''}',
        "${aqiCurentResponse.data?.iaqi?.t?.v ?? 0}°/${aqiCurentResponse.data?.iaqi?.h?.v ?? 0}% · Chỉ số AQI: ${aqiCurentResponse.data?.aqi ?? 0} · ${getQualityAQIText(getAQIRank((aqiCurentResponse.data?.aqi ?? 0).toDouble()))}",
        platformChannelSpecifics);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String? payload) async {
  if ((payload ?? "").isNotEmpty) {
    Get.to(() => DetailPollutionScreen(), arguments: payload);
  }
}
