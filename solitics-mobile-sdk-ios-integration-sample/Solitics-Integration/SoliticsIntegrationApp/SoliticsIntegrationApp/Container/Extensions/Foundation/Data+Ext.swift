//
//  Data+Ext.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 10/30/19.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//

import Foundation

extension Data
{
    var prettyPrintedJSONString: String?
    {
        let options: JSONSerialization.WritingOptions
        
        if #available(iOS 13.0, *)
        {
            options = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        }
        else if #available(iOS 11.0, *)
        {
            options = [.prettyPrinted, .sortedKeys]
        }
        else
        {
            options = [.prettyPrinted]
        }
        
        if let object = try? JSONSerialization.jsonObject(with: self, options: []),
           let data   = try? JSONSerialization.data(withJSONObject: object, options: options),
           let prettyPrintedString = String(data: data, encoding: .utf8)
        {
            return prettyPrintedString
        }
        else
        {
            return String(data: self, encoding: .utf8)
        }
    }
}
