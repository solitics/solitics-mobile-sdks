//
//  AppInternalError.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 14.02.2020.
//  Copyright © 2020 Serg Liamtsev. All rights reserved.
//

import Foundation

enum AppInternalError: Error, LocalizedError
{
    case error(errorMessage: String)
    case emptyUserCredentials
    
    var description: String
    {
        switch self {
        case .error(let errorMessage):
            return errorMessage
        case .emptyUserCredentials:
            return "User credentials is empty"
        }
    }
    
    var errorDescription: String?
    {
        return self.description
    }
    
    var nsError: NSError
    {
        switch self {
            
        case .error(let errorMessage):
            
            let userInfo: [String: Any] = [
                NSLocalizedDescriptionKey	    : errorMessage,
                NSLocalizedFailureReasonErrorKey: errorMessage
            ]
            return NSError(domain: Bundle.main.bundleIdentifier ?? "", code: -1001, userInfo: userInfo)
            
        case .emptyUserCredentials:
            
            let userInfo: [String: Any] = [
                NSLocalizedDescriptionKey       : self.description,
                NSLocalizedFailureReasonErrorKey: self.description
            ]
            return NSError(domain: Bundle.main.bundleIdentifier ?? "", code: -101, userInfo: userInfo)
            
        }
    }
    
}
