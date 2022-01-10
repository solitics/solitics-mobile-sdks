//
//  UniqueIdentifiable.swift
//  SoliticsDevelopmentApp
//
//  Created by Serg Liamthev on 21.04.2020.
//  Copyright © 2020 Serg Liamtsev. All rights reserved.
//
import Foundation
///
///
///
protocol UniqueIdentifiable {
    
    // NOTE: Required for Coordinator architecture implementation (ModuleReference UUID)
    var identifier: UUID { get set }
}
