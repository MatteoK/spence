//
//  ExpenseListSectionViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum ExpenseListSectionGroupingType {
    
    case month
    case day
    
}

protocol IExpenseListSectionViewModelFactory: class {
    
    var groupingType: ExpenseListSectionGroupingType { get set }
    func create(from expenses: [Expense]) -> [ExpenseListSectionViewModel]
    
}

final class ExpenseListSectionViewModelFactory: IExpenseListSectionViewModelFactory {
    
    let itemFactory: IExpenseListItemViewModelFactory
    var groupingType: ExpenseListSectionGroupingType = .day {
        didSet {
            itemFactory.dateFormat = itemDateFormat()
        }
    }
    
    private func itemDateFormat() -> ExpenseListItemDateFormat {
        switch groupingType {
        case .day:
            return .time
        case .month:
            return .dayTime
        }
    }
    
    init(itemFactory: IExpenseListItemViewModelFactory = ExpenseListItemViewModelFactory()) {
        self.itemFactory = itemFactory
    }
    
    func create(from expenses: [Expense]) -> [ExpenseListSectionViewModel] {
        return expenses
            .group(by: { self.sectionTitle(from: $0.date) } )
            .map {$1}
            .map { expenses -> (Date, [Expense])? in
                guard let first = expenses.first else { return nil }
                return (first.date, expenses)
            }
            .flatMap({$0})
            .sorted(by: { lhs, rhs in
                return lhs.0.timeIntervalSince1970 > rhs.0.timeIntervalSince1970
            })
            .map({ tuple -> ExpenseListSectionViewModel in
                return ExpenseListSectionViewModel(title: self.sectionTitle(from: tuple.0), items: items(from: tuple.1))
            })
    }
    
    private func sectionTitle(from date: Date) -> String {
        return sectionTitleDateFormatter().string(from: date)
    }
    
    private func sectionTitleDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat()
        return formatter
    }
    
    private func dateFormat() -> String {
        switch groupingType {
        case .day:
            return "dd.MM.yyyy"
        case .month:
            return "MMMM yyyy"
        }
    }
    
    
    private func toString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter.string(from: date)
    }
    
    private func items(from expenses: [Expense]) -> [ExpenseListItemViewModel] {
        return expenses.map({self.itemFactory.create(from: $0)})
    }
    
}

private extension Sequence {
    
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
    
}
