//
//  AlertPresenter.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 18.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
final class AlertPresenter: NSObject
{
    // MARK: - Error alert
    static func showErrorAlert(at vc: UIViewController, errorMessgage: String)
    {
        performOnMain {
            let alert = UIAlertController(title: "Error", message: errorMessgage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                
            })
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Error alert with closure
    static func showErrorAlertWithHandler(at vc: UIViewController, errorMessgage: String, handler: ((UIAlertAction) -> Void)? = nil)
    {
        performOnMain {
            let alert = UIAlertController(title: "Error", message: errorMessgage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Success alert
    static func showSuccessAlert(at vc: UIViewController, message: String)
    {
        performOnMain {
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                
            })
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func dismissModalControllerAndPresent(from vc: UIViewController, toPresent: UIViewController)
    {
        if let presentedVC = vc.presentedViewController {
            presentedVC.dismiss(animated: true, completion: {
                vc.present(toPresent, animated: true, completion: nil)
            })
        } else {
            vc.present(toPresent, animated: true, completion: nil)
        }
    }
}
