import UIKit
import Flutter
import FirebaseAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
	_ application: UIApplication,
	didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		var flutter_native_splash = 1
		UIApplication.shared.isStatusBarHidden = false

		GeneratedPluginRegistrant.register(with: self)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
	
	//Auth
	override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
			   let firebaseAuth = Auth.auth()
			   firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
	}
	override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
			   let firebaseAuth = Auth.auth()
			   if (firebaseAuth.canHandleNotification(userInfo)){
				   print(userInfo)
				   return
			   }
	}
}
