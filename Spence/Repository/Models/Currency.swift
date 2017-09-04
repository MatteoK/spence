//
//  Currency.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum Currency: String {
    
    case euro = "€"
    
    static var all: [Currency] = [.euro]
    static let defaultCurrency: Currency = .euro
    
    var symbol: String {
        return rawValue
    }
    
}
