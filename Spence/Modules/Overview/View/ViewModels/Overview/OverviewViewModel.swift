//
//  OverviewViewModel.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct OverviewViewModel {
    
    let thisMonthsExpenseProgress: Float
    let todaysExpenseProgress: Float
    let todaysBudget: String
    let monthlyBudget: String
    let todaysExpenses: String
    let thisMonthsExpenses: String
    let monthlyBudgetValue: Int
    
}

extension OverviewViewModel: Equatable {}

func ==(lhs: OverviewViewModel, rhs: OverviewViewModel) -> Bool {
    return lhs.thisMonthsExpenseProgress == rhs.thisMonthsExpenseProgress &&
        lhs.todaysExpenseProgress == rhs.todaysExpenseProgress &&
        lhs.todaysBudget == rhs.todaysBudget &&
        lhs.monthlyBudget == rhs.monthlyBudget &&
        lhs.todaysExpenses == rhs.todaysExpenses &&
        lhs.thisMonthsExpenses == rhs.thisMonthsExpenses &&
        lhs.monthlyBudgetValue == rhs.monthlyBudgetValue
}
