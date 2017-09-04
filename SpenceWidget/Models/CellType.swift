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
    case cancelButton
    case progressBar
    case dailySpending
    case monthlySpending
    
}

extension CellType: Equatable {}

func ==(lhs: CellType, rhs: CellType) -> Bool {
    switch (lhs, rhs) {
    case (.button(let leftAmount), .button(let rightAmount)):
        return leftAmount == rightAmount
    case (.enqueuedAmount, .enqueuedAmount):
        return true
    case (.cancelButton, .cancelButton):
        return true
    case (.progressBar, .progressBar):
        return true
    case (.dailySpending, .dailySpending):
        return true
    case (.monthlySpending, .monthlySpending):
        return true
    default:
        return false
    }
}
