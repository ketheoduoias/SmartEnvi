import UIKit
import Flutter
import GoogleMaps
import Firebase
import background_locator
import workmanager
import path_provider_ios

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
      UNUserNotificationCenter.current().delegate = self

    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyBBcxouAK2Lz1vUp75-zRjLlhz61wKS99o")

    GeneratedPluginRegistrant.register(with: self)
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }

    BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))

    registerOtherPlugins()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func registerOtherPlugins() {
      if !hasPlugin("io.flutter.plugins.pathprovider") {
          FLTPathProviderPlugin
              .register(with: registrar(forPlugin: "io.flutter.plugins.pathprovider")!)
      }
  }
  override func userNotificationCenter(
          _ center: UNUserNotificationCenter,
          willPresent notification: UNNotification,
          withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert) // shows banner even if app is in foreground
  }
}
