//
//  OverviewViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IOverviewViewModelFactory {
    
    func create(from data: OverviewData) -> OverviewViewModel
    
}

final class OverViewViewModelFactory: IOverviewViewModelFactory {
    
    func create(from data: OverviewData) -> OverviewViewModel {
        return OverviewViewModel(
            thisMonthsExpenseProgress: expenseProgress(budget: data.monthlyBudget, expenses: data.thisMonthsExpenses),
            todaysExpenseProgress: expenseProgress(budget: data.todaysBudged, expenses: data.todaysExpenses),
            todaysBudget: "of \(data.todaysBudged)",
            monthlyBudget: "of \(data.monthlyBudget)",
            todaysExpenses: "\(Currency.selected.symbol)\(String.thinSpace)\(data.todaysExpenses)",
            thisMonthsExpenses: "\(Currency.selected.symbol)\(String.thinSpace)\(data.thisMonthsExpenses)"
        )
    }
    
    private func expenseProgress(budget: Int, expenses: Int) -> Float {
        guard expenses < budget && budget > 0 else { return 1 }
        return Float(expenses) / Float(budget)
    }
    
}
