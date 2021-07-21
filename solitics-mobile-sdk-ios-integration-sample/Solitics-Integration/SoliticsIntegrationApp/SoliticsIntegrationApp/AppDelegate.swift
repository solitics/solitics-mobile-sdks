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
    
    override init()
    {
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
}
