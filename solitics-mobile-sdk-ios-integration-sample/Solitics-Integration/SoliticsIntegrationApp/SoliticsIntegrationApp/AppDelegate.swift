//
//  AppDelegate.swift
//  SoliticsIntegrationApp
//
//  Created by Arkadi Yoskovitz on 7/13/21.
//
import UIKit
import SoliticsSDK
import Firebase
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
        Solitics.activeGlobalLogs = false
        Solitics.activeSocketLogs = false
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
        FirebaseApp.configure()
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
extension AppDelegate : SoliticsLogListener
{
    func onLogMessage(_ message: String)
    {
        print("\(#function)::\(message)")
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
        print(#function)
    }
    
    /**
     * Called when the solitics popup message is closed.
     */
    func soliticsMessageDidDismissPopup()
    {
        print(#function)
    }
    
    /**
     * Called when the an item inside the solitics popup message is clicked.
     */
    func soliticsMessageDidTrigerAction()
    {
        print(#function)
    }
    
    func soliticsShouldDismissPopup(forNavigationTarget urlString: String) -> Bool
    {
        print(#function)
        /// Custom logic to determin if we shold dismiss the popup or not
        return true
    }
    
    func soliticsMessageDidClosePopup(forNavigationTarget urlString: String)
    {
        print(#function)
        /// Action to be taken after the popup was dismisses by the solitics system
    }
}
