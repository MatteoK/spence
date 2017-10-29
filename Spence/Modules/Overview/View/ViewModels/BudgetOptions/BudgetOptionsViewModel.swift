//
//  BudgetOptionsViewModel.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct BudgetOptionsViewModel {
    
    let options: [String]
    let selectedIndex: Int
    let currency: String
    
}

extension BudgetOptionsViewModel: Equatable {}

func ==(lhs: BudgetOptionsViewModel, rhs: BudgetOptionsViewModel) -> Bool {
    return lhs.options == rhs.options && lhs.selectedIndex == rhs.selectedIndex && lhs.currency == rhs.currency
}
