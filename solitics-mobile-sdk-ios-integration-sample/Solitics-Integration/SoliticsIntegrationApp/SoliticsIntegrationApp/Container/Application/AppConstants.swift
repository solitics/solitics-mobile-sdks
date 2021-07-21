//
//  AppConstants.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamtsev on 19.12.2019.
//  Copyright © 2019 Serg Liamtsev. All rights reserved.
//
import UIKit
///
///
///
// =====================================================================================================================
typealias VoidClosure    = ()  -> Void
typealias TypeClosure<T> = (T) -> Void
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
typealias VoidResult    = Swift.Result<Void, Error>
typealias TypeResult<T> = Swift.Result<T   , Error>
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
typealias VoidResultClosure    = (Swift.Result<Void, Error>) -> Void
typealias TypeResultClosure<T> = (Swift.Result<T   , Error>) -> Void
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
typealias DataUpdateInfo = [String: [String: Any]]
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
///
///
///
struct AppConstants
{
    static let imageCompressionCoefficient: CGFloat = 0.1
    static let herokuImageMaxBytesSize: Int = 10485760
}
///
///
///
struct LayoutConstants
{
    static let keyboardToolbarHeight: CGFloat = 40.0
}
