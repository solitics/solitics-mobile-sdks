//
//  BaseViewController.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 18.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import MessageUI
import SafariServices
import UIKit
///
///
///
class BaseViewController : UIViewController
{
    var identifier : UUID
    var hudElement : SpinnerVC
    
    // MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        self.identifier = UUID()
        self.hudElement = SpinnerVC()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeSwipeBackGestureState(isEnabled: true)
    }
    
    func changeNavBarVisibility(isHidden: Bool)
    {
        navigationItem.title = nil
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
    }
    
    func changeSwipeBackGestureState(isEnabled: Bool)
    {
        navigationController?.interactivePopGestureRecognizer?.delegate = isEnabled ? self : nil
    }
    
}
// MARK: - ProgressShowable
extension BaseViewController : ProgressShowable
{
    
}
// MARK: - ExternalURLOpenable
extension BaseViewController : ExternalURLOpenable
{
    
}
// MARK: - StatusBarResizable
extension BaseViewController : StatusBarResizable
{
    
}
// MARK: - UniqueIdentifiable
extension BaseViewController : UniqueIdentifiable
{
    
}
// MARK: - MFMailComposeViewControllerDelegate
extension BaseViewController : MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension BaseViewController : UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}

// MARK: - SFSafariViewControllerDelegate
extension BaseViewController : SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL)
    {
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
    {
        executeOnMain {
            
            guard !didLoadSuccessfully else { return }
            
            let error = "No Internet connection"
            AlertPresenter.showErrorAlertWithHandler(at: controller, errorMessgage: error, handler: { _ in
                
                controller.dismiss(animated: true, completion: nil)
            })
        }
    }
}
