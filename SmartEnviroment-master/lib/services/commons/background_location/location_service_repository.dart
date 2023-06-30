import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:background_locator/location_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pollution_environment/model/user_response.dart';
import 'package:pollution_environment/services/network/apis/users/user_api.dart';

import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class LocationServiceRepository {
  static final LocationServiceRepository _instance =
      LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  Future<void> init(Map<dynamic, dynamic> params) async {
    // final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // send?.send(null);
  }

  Future<void> dispose() async {
    if (kDebugMode) {
      print("***********Dispose callback handler");
    }
    // final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    if (kDebugMode) {
      print("========= Callback ====== $locationDto");
    }
    WidgetsFlutterBinding.ensureInitialized();
    // final AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails(
    //   '123',
    //   'Update user',
    //   channelDescription: 'Cập nhật thông tin người dùng',
    //   priority: Priority.high,
    //   importance: Importance.high,
    //   enableLights: true,
    //   playSound: false,
    //   color: const Color.fromARGB(255, 255, 0, 0),
    //   ledColor: const Color.fromARGB(255, 255, 0, 0),
    //   ledOnMs: 1000,
    //   ledOffMs: 500,
    // );
    // final NotificationDetails platformChannelSpecifics =
    //     NotificationDetails(android: androidPlatformChannelSpecifics);
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   "location: ${locationDto.latitude} ${locationDto.longitude}",
    //   "ok",
    //   platformChannelSpecifics,
    // );

    if (Platform.isAndroid) {
      SharedPreferencesAndroid.registerWith();
    } else if (Platform.isIOS) {
      SharedPreferencesIOS.registerWith();
    }
    String? userId = await UserStore().getUserId();
    if (userId != null) {
      UserAPI()
          .updateLocation(
              id: userId, lat: locationDto.latitude, lng: locationDto.longitude)
          .then((value) async {
        if (kDebugMode) {
          print("==== Update user track location done ======");
        }
      }, onError: (e) {
        if (kDebugMode) {
          print("===== Update track location error $e");
        }
      });
    }
    // final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // send?.send(locationDto);
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }
}
