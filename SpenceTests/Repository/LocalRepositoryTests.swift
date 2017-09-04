//
//  LocalRepositoryTests.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class LocalRepositoryTests: XCTestCase {
    
    private var localRepository: LocalRepository!
    private let userDefaultsSuite = "test.defaults"
    private let dateProvider = MockDateProvider()
    
    override func setUp() {
        super.setUp()
        localRepository = LocalRepository(defaults: UserDefaults(suiteName: userDefaultsSuite)!, dateProvider: dateProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults().removePersistentDomain(forName: userDefaultsSuite)
    }
    
    func test_whenAddingTodaysSpendings_thenTodaysSpendingsValueIsUpdated() {
        XCTAssertEqual(localRepository.todaysSpendings, 0)
        localRepository.addToTodaysSpendings(value: 5)
        XCTAssertEqual(localRepository.todaysSpendings, 5)
    }
    
    func test_monthlySpending_isSumOfDailySpendingsInMonth() {
        let firstDay = Date(timeIntervalSince1970: 0)
        dateProvider.date = firstDay
        localRepository.addToTodaysSpendings(value: 5)
        dateProvider.date = firstDay.adding(days: 1)
        localRepository.addToTodaysSpendings(value: 7)
        dateProvider.date = firstDay.adding(days: 2)
        localRepository.addToTodaysSpendings(value: 3)
        dateProvider.date = firstDay.adding(days: 32)
        localRepository.addToTodaysSpendings(value: 20)
        dateProvider.date = firstDay
        XCTAssertEqual(localRepository.thisMonthsSpendings, 15)
    }
    
    func test_todaysBudget_isRemainingBudgetDividedByRemainingDays() {
        localRepository.monthlyBudget = 290
        let firstDay = Date(timeIntervalSince1970: 0)
        dateProvider.date = firstDay
        localRepository.addToTodaysSpendings(value: 5)
        dateProvider.date = firstDay.adding(days: 1)
        localRepository.addToTodaysSpendings(value: 5)
        dateProvider.date = firstDay.adding(days: 2)
        XCTAssertEqual(localRepository.todaysBudget, 10)
    }
    
    func test_whenSettingSpendings_valuesAreCorrect() {
        let dateA = Date()
        let valueA = Float(1)
        let dateB = Date()
        let valueB = Float(2)
        let dateC = Date()
        let valueC = Float(3)
        let spendingA = Spending(date: dateA, value: valueA)
        let spendingB = Spending(date: dateB, value: valueB)
        let spendingC = Spending(date: dateC, value: valueC)
        localRepository.spendings = [spendingA, spendingB, spendingC]
        XCTAssertEqual(localRepository.spendings.count, 3)
        assertSpendingsAreEqual(left: localRepository.spendings[0], right: spendingA)
        assertSpendingsAreEqual(left: localRepository.spendings[1], right: spendingB)
        assertSpendingsAreEqual(left: localRepository.spendings[2], right: spendingC)
    }
    
    func assertSpendingsAreEqual(left: Spending, right: Spending) {
        XCTAssertEqual(Int(left.date.timeIntervalSince1970), Int(right.date.timeIntervalSince1970))
        XCTAssertEqual(left.value, right.value)
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
