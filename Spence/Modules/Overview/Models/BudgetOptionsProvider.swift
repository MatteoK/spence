//
//  BudgetOptionsProvider.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

final class BudgetOptionsProvider {
    
    static var options: [Int] {
        get {
            return (0..<100).map({ $0*10 })
        }
    }
    
}
