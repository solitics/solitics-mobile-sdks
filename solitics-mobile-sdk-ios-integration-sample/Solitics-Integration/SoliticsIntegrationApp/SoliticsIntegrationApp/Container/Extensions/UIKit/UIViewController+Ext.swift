//
//  UIViewController+Extension.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 3/4/19.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
extension UIViewController
{
    func showToast(_ message: String)
    {
        var style = ToastStyle()
        style.messageColor = .white
        style.titleAlignment = .center
        style.messageAlignment = .center
        style.titleColor = .white
        self.view.makeToast(message, duration: 3.0, position: .bottom, style: style)
    }
}
