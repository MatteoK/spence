//
//  ExpenseListItemViewModel.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct ExpenseListItemViewModel {
    
    let date: String
    let value: String
    let currency: String
    
}

extension ExpenseListItemViewModel: Equatable {}

func ==(lhs: ExpenseListItemViewModel, rhs: ExpenseListItemViewModel) -> Bool {
    return lhs.date == rhs.date && lhs.value == rhs.value && lhs.currency == rhs.currency
}
