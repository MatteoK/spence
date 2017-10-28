//
//  SpendingListItemFactoryTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class SpendingListItemFactoryTests: XCTestCase {
    
    private let factory = SpendingListItemViewModelFactory()
    
    func test_whenDateFormatTime_thenDateHasOnlyTime() {
        let date = Date.with(minute: 41, hour: 9, day: 24, month: 1, year: 1984)
        let spending = Spending(date: date, value: 0)
        let item = factory.create(from: spending)
        XCTAssertEqual(item.date, "09:41")
    }
    
    func test_whenDateFormatDayTime_thenDateHasDayAndTime() {
        factory.dateFormat = .dayTime
        let date = Date.with(minute: 41, hour: 9, day: 24, month: 1, year: 1984)
        let spending = Spending(date: date, value: 0)
        let item = factory.create(from: spending)
        XCTAssertEqual(item.date, "24. 09:41")
    }
    
    func test_whenConvertingFromSpending_thenUsesValueAndAddsCurrencySymbol() {
        let spending = Spending(date: Date(), value: 8)
        let item = factory.create(from: spending)
        XCTAssertEqual(item.value, "8\(Currency.selected.symbol)")
    }
    
}
