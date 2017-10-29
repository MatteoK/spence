//
//  ExpenseListItemViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum ExpenseListItemDateFormat {
    
    case time
    case dayTime
    
    var format: String {
        switch self {
        case .time:
            return "HH:mm"
        case .dayTime:
            return "dd. HH:mm"
        }
    }
    
}

protocol IExpenseListItemViewModelFactory: class {
    
    var dateFormat: ExpenseListItemDateFormat { get set }
    func create(from expense: Expense) -> ExpenseListItemViewModel
    
}

final class ExpenseListItemViewModelFactory: IExpenseListItemViewModelFactory {
    
    var dateFormat: ExpenseListItemDateFormat = .time
    
    func create(from expense: Expense) -> ExpenseListItemViewModel {
        return ExpenseListItemViewModel(
            date: string(from: expense.date),
            value: "\(Int(expense.value)),-",
            currency: "\(Currency.selected.symbol)"
        )
    }
    
    private func string(from date: Date) -> String {
        return dateFormatter().string(from:date)
    }
    
    private func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.format
        return formatter
    }
    
}
