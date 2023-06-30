import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pollution_environment/model/alert_model.dart';
import 'package:pollution_environment/model/pollution_response.dart';
import 'package:pollution_environment/views/screen/detail_pollution/detail_pollution_screen.dart';

import '../../views/components/custom_alert_dialog.dart';
import '../network/apis/notification/notification_api.dart';
import 'helper.dart';
import 'notification_service.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    // final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    // final notification = message.data['notification'];
  }
  // Or do other work.
}

Future<AudioPlayer> playSoundAlert() async {
  AudioCache cache = AudioCache();
  return await cache.play("sound_alert.mp3");
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final NotificationService _notificationService = NotificationService();

  setNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(
      (message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          _notificationService.showNotifications(message);
        }
        final jsonData = json.decode(message.data["data"]);
        if (jsonData["userCreated"] != null) {
          // Thông báo khẩn cấp
          Alert alert = Alert.fromJson(jsonData);
          playSoundAlert();
          Get.generalDialog(
            pageBuilder: (ctx, ani1, ani2) {
              return CustomAlertDialog(
                alert: alert,
              );
            },
            transitionBuilder: (context, a1, a2, widget) {
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                    opacity: a1.value,
                    child: CustomAlertDialog(
                      alert: alert,
                    )),
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
          );
        } else {
          PollutionModel pollution = PollutionModel.fromJson(jsonData);
          playSoundAlert();

          showOverlayNotificationPollution(pollution, notification);
        }
      },
    );
    //Message for Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new messageopen app event was published');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _notificationService.showNotifications(message);
      }
    });

    // With this token you can test it easily on your phone
    _firebaseMessaging.getToken().then((value) {
      if (value != null) NotificationApi().updateFCMToken(value);
    });
  }

  OverlaySupportEntry showOverlayNotificationPollution(
      PollutionModel pollution, RemoteNotification? notification) {
    return showOverlayNotification(
      (ctx) {
        return SafeArea(
          child: Card(
            color: getQualityColor(pollution.qualityScore),
            elevation: 15,
            child: ListTile(
              leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                      child: Image.asset(getAssetPollution(pollution.type)))),
              title: Text(
                notification?.title ?? "Thông báo",
                style: TextStyle(
                    color: (pollution.qualityScore ?? 0) <= 3
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notification?.body ?? "",
                style: TextStyle(
                    color: (pollution.qualityScore ?? 0) <= 3
                        ? Colors.white
                        : Colors.black),
              ),
              trailing: IconButton(
                onPressed: () {
                  OverlaySupportEntry.of(ctx)?.dismiss();
                },
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                OverlaySupportEntry.of(ctx)?.dismiss();
                Get.to(() => DetailPollutionScreen(), arguments: pollution.id);
              },
            ),
          ),
        );
      },
      duration: const Duration(seconds: 20),
      position: NotificationPosition.top,
    );
  }
}
