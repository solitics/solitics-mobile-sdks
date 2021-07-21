//
//  AppRouter.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 19.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//

import UIKit

final class AppRouter: NSObject
{
    static func pushMainScreen(at vc: UIViewController)
    {
        performOnMain {
            
            let mainVC: MainVC = MainVC()
            vc.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    static func popToSignInScreen(from navVC: UINavigationController)
    {
        performOnMain {
            
            guard let vc = navVC.viewControllers.first(where: { $0.isMember(of: SignInVC.self)}) else {
                
                let signInVC: SignInVC = SignInVC()
                navVC.setViewControllers([signInVC], animated: false)
                return
            }
            
            navVC.popToViewController(vc, animated: true)
        }
    }
}
