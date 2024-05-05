//
//  AppDelegate.swift
//  SoliticsIntegrationApp
//
//  Created by Arkadi Yoskovitz on 7/13/21.
//
import UIKit
import SoliticsSDK
///
///
///
@UIApplicationMain
class AppDelegate : UIResponder
{
    var window : UIWindow?
    let services: [ServiceProtocol]
    
    override init()
    {
        services = [
            // FirebaseService(),
            // OneSignalService(),
            SoliticsSDKService()
        ]
        super.init()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private functions
    /// ============================================================================================================ ///
    private func setup()
    {
        let accessoryView = KeyboardAccessoryToolbar()
        UITextField.appearance().inputAccessoryView = accessoryView
        UITextView.appearance().inputAccessoryView = accessoryView
    }
    private func navigateToInitialScreen()
    {
        let rootVC: UIViewController
        if Solitics.currentLoginInfo != nil
        {
            rootVC = MainVC()
        } else {
            rootVC = SignInVC()
        }
        Solitics.activeGlobalLogs = true
        Solitics.activeSocketLogs = true
        Solitics.activeRestflLogs = false
        
        Solitics.delegate = self
        Solitics.register(SoliticsLogListener: self)
        
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = navVC
    }
}
extension AppDelegate : UIApplicationDelegate
{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        navigateToInitialScreen()
        setup()
        window?.makeKeyAndVisible()
        UNUserNotificationCenter.current().delegate = self
        services.forEach({ $0.application(application, didFinishLaunchingWithOptions: launchOptions) })
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Trying to open url: \(url)")
        print("With options: \(options)")
        return true
    }
}
extension AppDelegate : SoliticsLogListener
{
    func onLogMessage(_ message: String)
    {
        NSLog("\(#function)::\(message)")
    }
}
extension AppDelegate : SoliticsPopupDelegate
{
    func soliticsShouldOpenMessage(with content: SOLPopupContent) -> Bool
    {
        print(#function)
        print(content.messageID)
        print(content.messageHTML)
        print(content.webhookParams)
        return true
    }
    /**
     * Called when the solitics popup message is displayed.
     */
    func soliticsMessageDidDisplayPopup()
    {
        NSLog(#function)
        
        // DispatchQueue.main.asyncAfter(wallDeadline: .now() + 30) {
        //
        //     // Solitics.dismissSoliticsPopup()
        //     // Solitics.onLogout()
        // }
    }
    /**
     * Called when the solitics popup message is closed.
     */
    func soliticsMessageDidDismissPopup()
    {
        NSLog(#function)
    }
    /**
     * Called when the an item inside the solitics popup message is clicked.
     */
    func soliticsMessageDidTrigerAction()
    {
        NSLog(#function)
    }
    
    func soliticsShouldDismissPopup(forNavigationTarget urlString: String) -> Bool {
        NSLog(#function)
        /// Custom logic to determin if we shold dismiss the popup or not
        return true
    }
    func soliticsMessageDidClosePopup(forNavigationTarget urlString: String) {
        NSLog(#function)
        /// Action to be taken after the popup was dismisses by the solitics system
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        services.forEach({ $0.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        services.forEach({ $0.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) })
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        services.forEach({ $0.application(application, didFailToRegisterForRemoteNotificationsWithError: error) })
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        services.forEach { $0.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        services.forEach({ $0.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler) })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}
