//
//  NSObject+Ext.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 17.04.2020.
//  Copyright © 2020 NLT. All rights reserved.
//

import Foundation

extension NSObject
{
    func executeOnMain(closure: @escaping VoidClosure)
    {
        if Thread.isMainThread
        {
            closure()
        }
        else
        {
            DispatchQueue.main.async { closure() }
        }
    }
    
    static func performOnMain(closure: @escaping VoidClosure)
    {
        if Thread.isMainThread
        {
            closure()
        }
        else
        {
            DispatchQueue.main.async { closure() }
        }
    }
}
