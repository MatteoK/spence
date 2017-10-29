//
//  LocalRepositoryTests.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

final class LocalRepositoryTests: XCTestCase {
    
    private var localRepository: LocalRepository!
    private let userDefaultsSuite = "test.defaults"
    private var dateProvider: MockDateProvider!
    private var defaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        dateProvider = MockDateProvider()
        defaults = UserDefaults(suiteName: userDefaultsSuite)!
        localRepository = LocalRepository(defaults: defaults, dateProvider: dateProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults().removePersistentDomain(forName: userDefaultsSuite)
    }
    
    func test_whenAddingTodaysExpenses_thenTodaysExpensesValueIsUpdated() {
        XCTAssertEqual(localRepository.todaysExpenses, 0)
        localRepository.addToTodaysExpenses(value: 5)
        XCTAssertEqual(localRepository.todaysExpenses, 5)
    }
    
    func test_monthlyExpenses_isSumOfDailyExpensesInMonth() {
        let firstDay = Date(timeIntervalSince1970: 0)
        dateProvider.date = firstDay
        localRepository.addToTodaysExpenses(value: 5)
        dateProvider.date = firstDay.adding(days: 1)
        localRepository.addToTodaysExpenses(value: 7)
        dateProvider.date = firstDay.adding(days: 2)
        localRepository.addToTodaysExpenses(value: 3)
        dateProvider.date = firstDay.adding(days: 32)
        localRepository.addToTodaysExpenses(value: 20)
        dateProvider.date = firstDay
        XCTAssertEqual(localRepository.thisMonthsExpenses, 15)
    }
    
    func test_todaysBudget_isRemainingBudgetDividedByRemainingDays() {
        localRepository.monthlyBudget = 290
        let firstDay = Date(timeIntervalSince1970: 0)
        dateProvider.date = firstDay
        localRepository.addToTodaysExpenses(value: 5)
        dateProvider.date = firstDay.adding(days: 1)
        localRepository.addToTodaysExpenses(value: 5)
        dateProvider.date = firstDay.adding(days: 2)
        XCTAssertEqual(localRepository.todaysBudget, 10)
    }
    
    func test_whenSettingExpenses_thenValuesAreCorrect() {
        let dateA = Date()
        let valueA = Float(1)
        let dateB = Date()
        let valueB = Float(2)
        let dateC = Date()
        let valueC = Float(3)
        let expenseA = Expense(date: dateA, value: valueA)
        let expenseB = Expense(date: dateB, value: valueB)
        let expenseC = Expense(date: dateC, value: valueC)
        localRepository.expenses = [expenseA, expenseB, expenseC]
        XCTAssertEqual(localRepository.expenses.count, 3)
        assertExpensesAreEqual(left: localRepository.expenses[0], right: expenseA)
        assertExpensesAreEqual(left: localRepository.expenses[1], right: expenseB)
        assertExpensesAreEqual(left: localRepository.expenses[2], right: expenseC)
    }
    
    func assertExpensesAreEqual(left: Expense, right: Expense) {
        XCTAssertEqual(Int(left.date.timeIntervalSince1970), Int(right.date.timeIntervalSince1970))
        XCTAssertEqual(left.value, right.value)
    }
    
    func test_whenDeleteExpenseIsCalled_thenExpenseIsDeleted() {
        let expenseA = Expense(date: Date(), value: 0)
        let expenseB = Expense(date: Date(), value: 1)
        let expenseC = Expense(date: Date(), value: 2)
        localRepository.expenses = [expenseA, expenseB, expenseC]
        localRepository.delete(expense: expenseB)
        XCTAssertEqual(localRepository.expenses, [expenseA, expenseC])
    }
    
    func test_whenAddingToTodaysExpense_thenChangeIsNotifiedToAllInstances() {
        let otherRepository = LocalRepository()
        let onChangeWasCalled = expectation(description: "on change was called")
        otherRepository.onChange = {
            onChangeWasCalled.fulfill()
        }
        localRepository.addToTodaysExpenses(value: 5)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_whenMonthlyBudgetIsChanged_thenChangeIsNotifiedToAllInstances() {
        let otherRepository = LocalRepository()
        let onChangeWasCalled = expectation(description: "on change was called")
        otherRepository.onChange = {
            onChangeWasCalled.fulfill()
        }
        localRepository.monthlyBudget = 10
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_whenDeletingExpense_thenChangeIsNotifiedToAllInstances() {
        let otherRepository = LocalRepository()
        let onChangeWasCalled = expectation(description: "on change was called")
        otherRepository.onChange = {
            onChangeWasCalled.fulfill()
        }
        let expense = Expense(date: Date(), value: 12)
        localRepository.expenses = [expense]
        localRepository.delete(expense: expense)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_whenAppBecomesActive_thenChangeIsNotifiedToAllInstances() {
        let onChangeWasCalled = expectation(description: "on change was called")
        let repository = LocalRepository()
        repository.onChange = {
            onChangeWasCalled.fulfill()
        }
        NotificationCenter.default.post(name: NotificationNames.appDidBecomeActive, object: nil)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_whenAddsExpense_thenExpenseIsAdded() {
        XCTAssertEqual(localRepository.expenses, [])
        let expense = Expense(date: Date(), value: 220)
        localRepository.add(expense: expense)
        XCTAssertEqual(localRepository.expenses.first, expense)
    }
    
    func test_whenAddingExpense_thenChangeIsNotifiedToAllInstances() {
        let otherRepository = LocalRepository()
        let onChangeWasCalled = expectation(description: "on change was called")
        otherRepository.onChange = {
            onChangeWasCalled.fulfill()
        }
        let expense = Expense(date: Date(), value: 12)
        localRepository.add(expense: expense)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

extension LocalRepositoryTests {
    
    final class MockDateProvider: IDateProvider {
        
        var date = Date()
        
        func currentDate() -> Date {
            return date
        }
        
    }
    
}

private extension Date {
    
    func adding(days: Int) -> Date {
        return addingTimeInterval(86400*TimeInterval(days))
    }
    
}
