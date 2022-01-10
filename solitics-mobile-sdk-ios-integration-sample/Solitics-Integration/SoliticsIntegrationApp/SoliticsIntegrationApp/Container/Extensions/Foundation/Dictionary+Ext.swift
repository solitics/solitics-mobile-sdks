//
//  Dictionary+Ext.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 01.04.2020.
//  Copyright © 2020 NLT. All rights reserved.
//
import Foundation
///
///
///
extension Dictionary {
    
    var jsonString: String? {
        
        let options: JSONSerialization.WritingOptions
        
        if #available(iOS 13.0, *) {
            
            options = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            
        } else if #available(iOS 11.0, *) {
            
            options = [.prettyPrinted, .sortedKeys]
            
        } else {
            
            options = [.prettyPrinted]
        }
        
        let rawData = try? JSONSerialization.data(withJSONObject: self, options: options)
        
        if let data = rawData , let jsonString = String(data: data, encoding: .utf8)
        {
            return jsonString
        }
        else
        {
            return nil
        }
    }
}
