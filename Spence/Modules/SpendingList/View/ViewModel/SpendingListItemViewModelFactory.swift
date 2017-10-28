//
//  SpendingListItemViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum SpendingListItemDateFormat {
    
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

protocol ISpendingListItemViewModelFactory: class {
    
    var dateFormat: SpendingListItemDateFormat { get set }
    func create(from spending: Spending) -> SpendingListItemViewModel
    
}

final class SpendingListItemViewModelFactory: ISpendingListItemViewModelFactory {
    
    var dateFormat: SpendingListItemDateFormat = .time
    
    func create(from spending: Spending) -> SpendingListItemViewModel {
        return SpendingListItemViewModel(date: string(from: spending.date), value: "\(Int(spending.value))\(Currency.selected.symbol)")
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
