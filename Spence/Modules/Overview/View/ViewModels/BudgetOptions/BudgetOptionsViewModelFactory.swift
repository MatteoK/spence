//
//  BudgetOptionsViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IBudgetOptionsViewModelFactory {
    
    func create(currentBudget: Int) -> BudgetOptionsViewModel
    
}

final class BudgetOptionsViewModelFactory: IBudgetOptionsViewModelFactory {
    
    func create(currentBudget: Int) -> BudgetOptionsViewModel {
        let index = BudgetOptionsProvider.options.index(of: currentBudget) ?? 0
        let options = BudgetOptionsProvider.options.map({ "\($0)\(Currency.selected.symbol)" })
        return BudgetOptionsViewModel(options: options, selectedIndex: index)
    }
    
}
