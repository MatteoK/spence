//
//  SpendingListSectionViewModelFactory.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum SpendingListSectionGroupingType {
    
    case month
    case day
    
}

protocol ISpendingListSectionViewModelFactory: class {
    
    var groupingType: SpendingListSectionGroupingType { get set }
    func create(from spendings: [Spending]) -> [SpendingListSectionViewModel]
    
}

final class SpendingListSectionViewModelFactory: ISpendingListSectionViewModelFactory {
    
    let itemFactory: ISpendingListItemViewModelFactory
    var groupingType: SpendingListSectionGroupingType = .day {
        didSet {
            itemFactory.dateFormat = itemDateFormat()
        }
    }
    
    private func itemDateFormat() -> SpendingListItemDateFormat {
        switch groupingType {
        case .day:
            return .time
        case .month:
            return .dayTime
        }
    }
    
    init(itemFactory: ISpendingListItemViewModelFactory = SpendingListItemViewModelFactory()) {
        self.itemFactory = itemFactory
    }
    
    func create(from spendings: [Spending]) -> [SpendingListSectionViewModel] {
        return spendings
            .group(by: { self.sectionTitle(from: $0.date) } )
            .map {$1}
            .map { spendings -> (Date, [Spending])? in
                guard let first = spendings.first else { return nil }
                return (first.date, spendings)
            }
            .flatMap({$0})
            .sorted(by: { lhs, rhs in
                return lhs.0.timeIntervalSince1970 > rhs.0.timeIntervalSince1970
            })
            .map({ tuple -> SpendingListSectionViewModel in
                return SpendingListSectionViewModel(title: self.sectionTitle(from: tuple.0), items: items(from: tuple.1))
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
    
    private func items(from spendings: [Spending]) -> [SpendingListItemViewModel] {
        return spendings.map({self.itemFactory.create(from: $0)})
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
