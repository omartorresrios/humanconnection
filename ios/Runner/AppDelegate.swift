import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	
	var flutterChannel: FlutterMethodChannel?
	
	override func application(_ application: UIApplication,
							  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		GeneratedPluginRegistrant.register(with: self)
		UNUserNotificationCenter.current().delegate = self
		application.registerForRemoteNotifications()
		if let controller = window?.rootViewController as? FlutterViewController {
			flutterChannel = FlutterMethodChannel(name: "com.example.humanconnection.notifications",
												  binaryMessenger: controller.binaryMessenger)
		}
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
	
	// notification on foreground
	override func userNotificationCenter(_ center: UNUserNotificationCenter,
										 willPresent notification: UNNotification,
										 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		flutterChannel?.invokeMethod("onForegroundNotificationReceived",
									 arguments: notification.request.content.userInfo)
		completionHandler([.alert, .sound, .badge])
	}

	// notification tapped
	override func userNotificationCenter(_ center: UNUserNotificationCenter,
										 didReceive response: UNNotificationResponse,
										 withCompletionHandler completionHandler: @escaping () -> Void) {
		flutterChannel?.invokeMethod("onTappedNotificationReceived", arguments: response.notification.request.content.userInfo)
		completionHandler()
	}
	
	// silent nofitication in both foreground and background
	override func application(_ application: UIApplication,
							  didReceiveRemoteNotification userInfo: [AnyHashable : Any],
							  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		flutterChannel?.invokeMethod("onSilentNotificationReceived", arguments: userInfo)
		completionHandler(UIBackgroundFetchResult.newData)
	}
}
