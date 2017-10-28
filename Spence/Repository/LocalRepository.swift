//
//  LocalRepository.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol ILocalRepository: class {
    
    var monthlyBudget: Float { get set }
    var todaysExpenses: Float { get }
    func addToTodaysExpenses(value: Float)
    var thisMonthsExpenses: Float { get }
    var percentSpentToday: Float { get }
    var todaysBudget: Float { get }
    var expenses: [Expense] { get }
    
}

final class LocalRepository: ILocalRepository {
    
    let defaults: UserDefaults
    let dateProvider: IDateProvider
    
    init(defaults: UserDefaults = UserDefaults(suiteName: .defaultsSuiteName)!, dateProvider: IDateProvider = DateProvider()) {
        self.defaults = defaults
        self.dateProvider = dateProvider
    }
    
    var monthlyBudget: Float {
        get {
            return defaults.float(forKey: .monthlyBudgetKey)
        }
        set {
            defaults.set(newValue, forKey: .monthlyBudgetKey)
        }
    }
    
    var todaysExpenses: Float {
        get {
            return expenses.filter({ Calendar.current.isDateInToday($0.date) }).map({ $0.value }).reduce(0, +)
        }
    }
    
    var expenses: [Expense] {
        get {
            return (defaults.object(forKey: .expensesKey) as? [String])?
                .map({ Expense.from(string: $0) })
                .flatMap({$0}) ?? []
        }
        set {
            defaults.set(newValue.map({ $0.toString() }), forKey: .expensesKey)
        }
    }
    
    func addToTodaysExpenses(value: Float) {
        expenses.append(Expense(date: dateProvider.currentDate(), value: value))
    }
    
    var thisMonthsExpenses: Float {
        return expenses
            .filter({ Calendar.current.isDate($0.date, equalTo: dateProvider.currentDate(), toGranularity: .month) })
            .map({ $0.value })
            .reduce(0, +)
    }
    
    var percentSpentToday: Float {
        guard todaysBudget > 0 else { return 1 }
        return todaysExpenses / todaysBudget
    }
    
    var todaysBudget: Float {
        let remainingBudget = monthlyBudget - (thisMonthsExpenses - todaysExpenses)
        let calculatedBudget = remainingBudget / Float(daysLeftInCurrentMonth())
        return max(calculatedBudget, 0)
    }
    
    private func daysLeftInCurrentMonth() -> Int {
        return daysInCurrentMonth() - currentDay()
    }
    
    private func daysInCurrentMonth() -> Int {
        let cal = Calendar(identifier: .gregorian)
        let monthRange = cal.range(of: .day, in: .month, for: dateProvider.currentDate())!
        return monthRange.count
    }
    
    private func currentDay() -> Int {
        return Calendar.current.component(.day, from: dateProvider.currentDate())
    }
    
}

private extension String {
    
    static let monthlyBudgetKey = "monthlyBudget"
    static let defaultsSuiteName = "group.spence"
    static let expensesKey = "expensesKey"
    
}
