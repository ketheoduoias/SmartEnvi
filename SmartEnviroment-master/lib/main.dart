import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pollution_environment/model/favorite_model.dart';
import 'package:pollution_environment/model/waqi/waqi_ip_model.dart';
import 'package:pollution_environment/routes/app_pages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, kIsWeb;
import 'package:pollution_environment/services/commons/background_location/location_background.dart';
import 'package:pollution_environment/services/commons/constants.dart';
import 'package:pollution_environment/services/commons/notification_service.dart';
import 'package:pollution_environment/services/commons/theme.dart';
import 'package:pollution_environment/services/network/api_service.dart';
import 'package:pollution_environment/services/network/apis/waqi/waqi.dart';
import 'package:pollution_environment/views/components/custom_loading.dart';
import 'package:workmanager/workmanager.dart';

const fetchLocationBackground = "fetchLocationBackground";
const fetchAQIBackground = "fetchAQIBackground";
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case Workmanager.iOSBackgroundTask:
        if (kDebugMode) {
          print("The iOS background fetch was triggered");
        }
        try {
          await LocationBackground.initPlatformState();
          WAQIIpResponse aqiCurentResponse = await WaqiAPI().getAQIByIP();

          NotificationService notificationService = NotificationService();
          await notificationService.showCurrentAQI(aqiCurentResponse);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        break;
      case fetchAQIBackground:
        try {
          WAQIIpResponse aqiCurentResponse = await WaqiAPI().getAQIByIP();

          NotificationService notificationService = NotificationService();
          await notificationService.showCurrentAQI(aqiCurentResponse);
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        break;
      case fetchLocationBackground:
        await LocationBackground.initPlatformState();
    }
    return Future.value(true);
  });
}

void main() async {
  await init();
  await Hive.initFlutter();
  await Hive.openBox(kHiveBox);
  Hive.registerAdapter(FavoriteAdapter());
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  APIService().init();
  runApp(const MyApp());
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDZUra8Uh6Bgv3VuPqQMfVsC9gUIjbGf_4",
          appId: "1:86534504753:web:ee8ddb5fc22d6f4cf3b010",
          messagingSenderId: "86534504753",
          projectId: "smartenviroment"),
    );
  } else {
    await Firebase.initializeApp();
  }

  await NotificationService().init();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..customAnimation = CustomAnimation()
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..maskType = EasyLoadingMaskType.black
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..progressColor = Colors.white
      ..backgroundColor = Theme.of(context).primaryColor
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..userInteractions = false
      ..dismissOnTap = false;
    LocationBackground.initPlatformState();
    // Workmanager().cancelAll();
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    if (Platform.isAndroid) {
      Workmanager().registerPeriodicTask(
        fetchAQIBackground,
        fetchAQIBackground,
        frequency: const Duration(minutes: 120),
      );
      Workmanager().registerPeriodicTask(
        fetchLocationBackground,
        fetchLocationBackground,
        frequency: const Duration(minutes: 15),
      );
    }
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return OverlaySupport.global(
      child: DismissKeyboard(
        child: ValueListenableBuilder(
            valueListenable: Hive.box(kHiveBox).listenable(),
            builder: (context, box, widget) {
              var themeMode = getThemeMode((box as Box).get(kThemeMode));
              return GetMaterialApp(
                theme: themeLight(),
                darkTheme: themeDark(),
                themeMode: themeMode,
                initialRoute: Routes.INITIAL,
                getPages: AppPages.pages,
                // defaultTransition: Transition.cupertino,
                debugShowCheckedModeBanner: false,
                title: "Smart Environment",
                builder: EasyLoading.init(),
                scrollBehavior: MyCustomScrollBehavior(),
              );
            }),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // xóa hiệu ứng cuộn ở các cạnh
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
