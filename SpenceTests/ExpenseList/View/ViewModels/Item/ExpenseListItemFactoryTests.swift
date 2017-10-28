//
//  ExpenseListItemFactoryTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

final class ExpenseListItemFactoryTests: XCTestCase {
    
    private let factory = ExpenseListItemViewModelFactory()
    
    func test_whenDateFormatTime_thenDateHasOnlyTime() {
        let date = Date.with(minute: 41, hour: 9, day: 24, month: 1, year: 1984)
        let expense = Expense(date: date, value: 0)
        let item = factory.create(from: expense)
        XCTAssertEqual(item.date, "09:41")
    }
    
    func test_whenDateFormatDayTime_thenDateHasDayAndTime() {
        factory.dateFormat = .dayTime
        let date = Date.with(minute: 41, hour: 9, day: 24, month: 1, year: 1984)
        let expense = Expense(date: date, value: 0)
        let item = factory.create(from: expense)
        XCTAssertEqual(item.date, "24. 09:41")
    }
    
    func test_whenConvertingFromExpense_thenUsesValueAndAddsCurrencySymbol() {
        let expense = Expense(date: Date(), value: 8)
        let item = factory.create(from: expense)
        XCTAssertEqual(item.value, "8\(Currency.selected.symbol)")
    }
    
}
