//
//  Currency.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

private let defaultsKey = "Currency_userDefaultsKey"

enum Currency: String {
    
    case euro = "€"
    
    static var defaults = UserDefaults.standard
    static var all: [Currency] = [.euro]
    static let defaultCurrency: Currency = .euro
    
    var symbol: String {
        return rawValue
    }
    
    static var selected: Currency {
        get {
            guard let rawValue = defaults.string(forKey: defaultsKey),
                let currency = Currency(rawValue: rawValue) else {
                    return Currency.defaultCurrency
            }
            return currency
        }
        set {
            defaults.set(newValue.rawValue, forKey: defaultsKey)
        }
    }
    
}
