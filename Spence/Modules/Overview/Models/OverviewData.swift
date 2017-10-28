//
//  OverviewData.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct OverviewData {
    
    let monthlyBudget: Int
    let todaysBudged: Int
    let thisMonthsExpenses: Int
    let todaysExpenses: Int
    
}

extension OverviewData: Equatable {}

func ==(lhs: OverviewData, rhs: OverviewData) -> Bool {
    return lhs.monthlyBudget == rhs.monthlyBudget &&
        lhs.todaysBudged == rhs.todaysBudged &&
        lhs.todaysBudged == rhs.todaysBudged &&
        lhs.thisMonthsExpenses == rhs.thisMonthsExpenses &&
        lhs.todaysExpenses == rhs.todaysExpenses
}
