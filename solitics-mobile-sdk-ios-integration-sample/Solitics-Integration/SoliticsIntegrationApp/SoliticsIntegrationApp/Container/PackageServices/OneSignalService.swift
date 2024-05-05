////
////  OneSignalService.swift
////  SoliticsIntegrationApp
////
////  Created by Alex Pinhasov on 14/12/2023.
////
//import UIKit
//import OneSignalFramework
//
//class OneSignalService: ServiceProtocol {
//    
//    private let apiKey: String = "e226f9bf-1893-44b0-b704-e4eff1d2a1fc"
//    // 24d8f122-544e-4fe0-b6fe-a6f59514df99
//    // MARK: - NotificationHandlerProtocol
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
//        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
//        OneSignal.initialize(apiKey, withLaunchOptions: launchOptions)
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        completionHandler(.noData)
//    }
//    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        NSLog("OneSignal device token -> \(String(describing: OneSignal.User.pushSubscription.token))")
//    }
//    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print(error)
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        // completionHandler([])
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // completionHandler()
//    }
//    
//    // MARK: - NotificationServiceProtocol
//    
//    func canHandleNotification(userInfo: [AnyHashable : Any]) -> Bool {
//        return getImagePath(fromUserInfo: userInfo)?.contains("onesignal.com") == true
//    }
//    
//    func imageURL(fromUserInfo userInfo: [AnyHashable : Any]) -> URL? {
//        guard let imagePath = getImagePath(fromUserInfo: userInfo),
//              let url = URL(string: imagePath) else { return nil }
//        return url
//    }
//    
//    private func getImagePath(fromUserInfo userInfo: [AnyHashable : Any]) -> String? {
//        guard let userInfo = userInfo as? [String: Any],
//              let attribute = userInfo["att"] as? [String: Any],
//              let imagePath = attribute["id"] as? String else { return nil }
//        return imagePath
//    }
//}
