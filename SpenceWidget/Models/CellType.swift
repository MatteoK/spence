//
//  CellType.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum CellType {
    
    case button(ButtonAmount)
    case enqueuedAmount
    case progressBar
    case dailyExpenses
    case monthlyExpenses
    
}

extension CellType: Equatable {}

func ==(lhs: CellType, rhs: CellType) -> Bool {
    switch (lhs, rhs) {
    case (.button(let leftAmount), .button(let rightAmount)):
        return leftAmount == rightAmount
    case (.enqueuedAmount, .enqueuedAmount):
        return true
    case (.progressBar, .progressBar):
        return true
    case (.dailyExpenses, .dailyExpenses):
        return true
    case (.monthlyExpenses, .monthlyExpenses):
        return true
    default:
        return false
    }
}
