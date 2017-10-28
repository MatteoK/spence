//
//  SpendingListSectionViewModelFactoryTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class SpendingListSectionViewModelFactoryTests: XCTestCase {
    
    private var factory: SpendingListSectionViewModelFactory!
    private let itemFactory = MockItemFactory()
    
    override func setUp() {
        super.setUp()
        factory = SpendingListSectionViewModelFactory(itemFactory: itemFactory)
    }
    
    func test_whenGroupTypeIsDay_thenSectionsAreGroupedByDay() {
        factory.groupingType = .day
        let sections = factory.create(from: spendings())
        XCTAssertEqual(sections.count, 4)
        XCTAssertEqual(sections[0].title, "01.01.2018")
        XCTAssertEqual(sections[1].title, "31.12.2017")
        XCTAssertEqual(sections[2].title, "24.12.2017")
        XCTAssertEqual(sections[3].title, "31.10.2017")
    }
    
    func test_whenGroupTypeIsDay_thenItemDateFormatIsTime() {
        factory.groupingType = .day
        XCTAssertEqual(factory.itemFactory.dateFormat, .time)
    }
    
    func test_whenGroupTypeIsMonth_thenSectionsAreGroupedByMonth() {
        factory.groupingType = .month
        let sections = factory.create(from: spendings())
        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].title, "January 2018")
        XCTAssertEqual(sections[1].title, "December 2017")
        XCTAssertEqual(sections[2].title, "October 2017")
    }
    
    func test_whenGroupTypeIsMonth_thenItemDateFormatIsDayTime() {
        factory.groupingType = .month
        XCTAssertEqual(factory.itemFactory.dateFormat, .dayTime)
    }
    
    func test_whenGeneratesItems_thenUsesItemFactory() {
        factory.groupingType = .month
        let sections = factory.create(from: spendings())
        sections.map({ $0.items }).flatMap({$0}).forEach({ item in
            XCTAssertEqual(item, itemFactory.result)
        })
    }
    
    private func spendings() -> [Spending] {
        let halloween = Date.with(day: 31, month: 10, year: 2017)
        let christmas = Date.with(day: 24, month: 12, year: 2017)
        let newYearsEve = Date.with(day: 31, month: 12, year: 2017)
        let newYears = Date.with(day: 1, month: 1, year: 2018)
        return [halloween, christmas, newYearsEve, newYears].map({ Spending(date: $0, value: 0)} )
    }
    
}

extension SpendingListSectionViewModelFactoryTests {
    
    fileprivate class MockItemFactory: ISpendingListItemViewModelFactory {
        
        let result = SpendingListItemViewModel(date: "Monday", value: "27")
        
        var dateFormat: SpendingListItemDateFormat = .time
        
        func create(from spending: Spending) -> SpendingListItemViewModel {
            return result
        }
        
    }
    
}
