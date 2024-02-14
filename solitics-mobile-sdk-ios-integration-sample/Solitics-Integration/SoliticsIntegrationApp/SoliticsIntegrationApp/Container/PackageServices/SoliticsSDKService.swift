//
//  SoliticsSDKService
//  SoliticsDevelopmentApp
//
//  Created by Alex Pinhasov on 12/12/2023.
//
import SoliticsSDK
import UIKit

class SoliticsSDKService : NSObject {
    
}

extension SoliticsSDKService: ServiceProtocol
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?)
    {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        NSLog("InternalTesting: application:didReceiveRemoteNotification:fetchCompletionHandler:")

        SoliticsSDK.Solitics.didClickPushNotification(for: userInfo)
        
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        NSLog("InternalTesting: userNotificationCenter:willPresent:withCompletionHandlers:")
        
        let payload = notification.request.content.userInfo
        SoliticsSDK.Solitics.didClickPushNotification(for: payload)
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        NSLog("InternalTesting: userNotificationCenter:didReceive:withCompletionHandler: ")
        SoliticsSDK.Solitics.didReceivePushNotificationResponse(for: response)
        completionHandler()
    }
    
    func canHandleNotification(userInfo: [AnyHashable : Any]) -> Bool
    {
        return false
    }
    
    func imageURL(fromUserInfo userInfo: [AnyHashable : Any]) -> URL?
    {
        return nil
    }
}
