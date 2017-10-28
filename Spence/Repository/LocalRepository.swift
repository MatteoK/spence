//
//  LocalRepository.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol ILocalRepository {
    
    var monthlyBudget: Float { get set }
    var todaysSpendings: Float { get }
    func addToTodaysSpendings(value: Float)
    var thisMonthsSpendings: Float { get }
    var percentSpentToday: Float { get }
    var todaysBudget: Float { get }
    var spendings: [Spending] { get }
    
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
    
    var todaysSpendings: Float {
        get {
            return spendings.filter({ Calendar.current.isDateInToday($0.date) }).map({ $0.value }).reduce(0, +)
        }
    }
    
    var spendings: [Spending] {
        get {
            return (defaults.object(forKey: .spendingsKey) as? [String])?
                .map({ Spending.from(string: $0) })
                .flatMap({$0}) ?? []
        }
        set {
            defaults.set(newValue.map({ $0.toString() }), forKey: .spendingsKey)
        }
    }
    
    func addToTodaysSpendings(value: Float) {
        spendings.append(Spending(date: dateProvider.currentDate(), value: value))
    }
    
    var thisMonthsSpendings: Float {
        return spendings
            .filter({ Calendar.current.isDate($0.date, equalTo: dateProvider.currentDate(), toGranularity: .month) })
            .map({ $0.value })
            .reduce(0, +)
    }
    
    var percentSpentToday: Float {
        guard todaysBudget > 0 else { return 1 }
        return todaysSpendings / todaysBudget
    }
    
    var todaysBudget: Float {
        let remainingBudget = monthlyBudget - (thisMonthsSpendings - todaysSpendings)
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
    static let dailySpendingsKey = "dailySpendings"
    static let defaultsSuiteName = "group.spence"
    static let spendingsKey = "currency"
    
}
