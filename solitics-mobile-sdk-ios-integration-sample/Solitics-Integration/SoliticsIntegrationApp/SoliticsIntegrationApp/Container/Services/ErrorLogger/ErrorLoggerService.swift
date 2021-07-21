//
//  ErrorLoggerService.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 14.02.2020.
//  Copyright © 2020 Serg Liamtsev. All rights reserved.
//

import Foundation
import os

final class ErrorLoggerService: NSObject
{
    // MARK: - Error logging
    static func logWithTrace(error: Error,
                             _ file: String = #file,
                             _ function: String = #function,
                             _ line: Int = #line
    ) {
        #if DEBUG
        // assertionFailure(errorMessage)
        #else
        let nsError = (error as NSError)
        if error is URLError || nsError.domain == NSURLErrorDomain {
            // NOTE: - Do not send network errors logs to crash logging SDK
        } else {
            
            ErrorLoggerService.logWithTrace(error.localizedDescription, file, function, line)
        }
        #endif
    }
    
    // MARK: - Network error logging (response parsing failure cases)
    static func logNetworkError(endpoint: String,
                                responseData: Data,
                                statusCode: Int,
                                _ file: String = #file,
                                _ function: String = #function,
                                _ line: Int = #line
    ) {
        let responseStr: String = String(data: responseData, encoding: .utf8) ?? ""
        let responseJSON: String = responseData.prettyPrintedJSONString ?? responseStr
        let message: String = "Network error - \(endpoint), code - \(statusCode), response - \(responseJSON)"
        #if DEBUG
        // assertionFailure(message)
        #else
        ErrorLoggerService.logWithTrace(message, file, function, line)
        #endif
    }
    
    /// Log your custom error message to third-party SDK (Crashlytics, Bugfender and etc.)
    /// - Parameters:
    ///   - errorMessage: your error messaeg
    ///   - file: source file name
    ///   - function: function name
    ///   - line: source file line number, that raised error
    static func logWithTrace(_ errorMessage: String,
                             _ file: String = #file,
                             _ function: String = #function,
                             _ line: Int = #line
    ) {
        #if DEBUG
        // assertionFailure(errorMessage)
        #else
        // let error = AppInternalError.error(errorMessage: errorMessage)
        if #available(iOS 10.0, *) {
            os_log("%@", log: .error, type: .error, errorMessage)
        }
        #endif
    }    
}
