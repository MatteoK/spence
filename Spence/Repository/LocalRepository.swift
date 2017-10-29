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
    func delete(expense: Expense)
    var onChange: (()->Void)? { get set }
    func add(expense: Expense)
    
}

final class LocalRepository: ILocalRepository {
    
    let defaults: UserDefaults
    let dateProvider: IDateProvider
    private let changeNotificationName = NSNotification.Name(rawValue: "LocalRepository_didChange")
    
    var onChange: (()->Void)?
    
    init(defaults: UserDefaults = UserDefaults(suiteName: .defaultsSuiteName)!, dateProvider: IDateProvider = DateProvider()) {
        self.defaults = defaults
        self.dateProvider = dateProvider
        subscribeChangeNotification()
        subscribeAppDidBecomeActiveNotification()
    }
    
    private func subscribeChangeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChange),
            name: changeNotificationName,
            object: nil)
    }
    
    private func subscribeAppDidBecomeActiveNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChange),
            name: NotificationNames.appDidBecomeActive,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var monthlyBudget: Float {
        get {
            return defaults.float(forKey: .monthlyBudgetKey)
        }
        set {
            defaults.set(newValue, forKey: .monthlyBudgetKey)
            notifyChange()
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
        notifyChange()
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
    
    func delete(expense: Expense) {
        guard let index = expenses.index(of: expense) else { return }
        expenses.remove(at: index)
        notifyChange()
    }
    
    private func notifyChange() {
        NotificationCenter.default.post(name: changeNotificationName, object: nil)
    }
    
    @objc func didChange() {
        onChange?()
    }
    
    func add(expense: Expense) {
        expenses.append(expense)
        notifyChange()
    }
    
}

private extension String {
    
    static let monthlyBudgetKey = "monthlyBudget"
    static let defaultsSuiteName = "group.spence"
    static let expensesKey = "expensesKey"
    
}

class DateContainer: NSCoding {
    
    let date = Date()
    
    init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        aDecoder.decodeObject(forKey: "date")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
    }
    
}
