//
//  StatusBarResizable.swift
//
//  Created by Serg Liamtsev on 21.11.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
protocol StatusBarResizable {}
///
///
///
extension StatusBarResizable where Self: UIResponder
{
    static func calculateStatusBarHeight() -> CGFloat
    {
        if #available(iOS 11.0, *)
        {
            guard let topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top else {
                let message: String = "Unable to get top inset"
                ErrorLoggerService.logWithTrace(message)
                preconditionFailure(message)
            }
            guard topInset == 0 else {
                return topInset
            }
            return 20
            
        } else {
            return 20
        }
        
    }
    
}
