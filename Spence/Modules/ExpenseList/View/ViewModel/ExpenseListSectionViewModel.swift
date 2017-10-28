//
//  ExpenseListSectionViewModel.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct ExpenseListSectionViewModel {
    
    let title: String
    let items: [ExpenseListItemViewModel]
    
}

extension ExpenseListSectionViewModel: Equatable {}

func ==(lhs: ExpenseListSectionViewModel, rhs: ExpenseListSectionViewModel) -> Bool {
    return lhs.title == rhs.title && lhs.items == rhs.items
}
