//
//  FirebaseService.swift
//  SoliticsDevelopmentApp
//
//  Created by Alex Pinhasov on 12/12/2023.
//
import UIKit
import FirebaseCore
import FirebaseMessaging

class FirebaseService: NSObject, MessagingDelegate {
    private let imageDic = "fcm_options"
    private let imageKey = "image"
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(messaging)
        print(String(describing: fcmToken))
        NSLog("Firebase token -> \(String(describing: fcmToken))")

    }
}

extension FirebaseService: ServiceProtocol {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //completionHandler()
    }
    
    func canHandleNotification(userInfo: [AnyHashable : Any]) -> Bool {
        return userInfo[imageDic] != nil
    }
    
    func imageURL(fromUserInfo userInfo: [AnyHashable : Any]) -> URL? {
        guard let imageDic = userInfo[imageDic] as? [String: String],
              let attachmentMedia = imageDic[imageKey],
              let url = URL(string: attachmentMedia) else {
            return nil
        }
        return url
    }
}
