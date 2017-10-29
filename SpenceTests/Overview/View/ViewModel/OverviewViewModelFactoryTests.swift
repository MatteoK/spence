//
//  OverviewViewModelFactoryTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class OverviewViewModelFactoryTests: XCTestCase {
    
    private let factory = OverViewViewModelFactory()
    private let data = OverviewData(monthlyBudget: 100, todaysBudged: 20, thisMonthsExpenses: 10, todaysExpenses: 5)
    private var viewModel: OverviewViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = factory.create(from: data)
    }
    
    func test_whenConvertsToViewModel_thenMonthlyBudgetIsCorrect() {
        XCTAssertEqual(viewModel.monthlyBudget, "of 100")
    }
    
    func test_whenConvertsToViewModel_thenThisMonthsExpensesIsCorrect() {
        XCTAssertEqual(viewModel.thisMonthsExpenses, "\(Currency.selected.symbol)\(String.thinSpace)10")
    }
    
    func test_whenConvertsToViewModel_thenTodaysBudgetIsCorrect() {
        XCTAssertEqual(viewModel.todaysBudget, "of 20")
    }
    
    func test_whenConvertsToViewModel_thenTodaysExpensesIsCorrect() {
        XCTAssertEqual(viewModel.todaysExpenses, "\(Currency.selected.symbol)\(String.thinSpace)5")
    }
    
    func test_whenConvertsToViewModel_thenMonthlyExpenseProgressIsCorrect() {
        XCTAssertEqual(viewModel.thisMonthsExpenseProgress, 0.1)
    }
    
    func test_whenConvertsToViewModel_thenTodaysExpenseProgressIsCorrect() {
        XCTAssertEqual(viewModel.todaysExpenseProgress, 0.25)
    }
    
    func test_whenMonthlyBudgetIsZero_thenThisMonthsExpenseProgressIsOne() {
        let data = OverviewData(monthlyBudget: 0, todaysBudged: 0, thisMonthsExpenses: 100, todaysExpenses: 0)
        let viewModel = factory.create(from: data)
        XCTAssertEqual(viewModel.thisMonthsExpenseProgress, 1)
    }
    
    func test_whenTodaysBudgetIsZero_thenTodaysExpenseProgressIsOne() {
        let data = OverviewData(monthlyBudget: 0, todaysBudged: 0, thisMonthsExpenses: 0, todaysExpenses: 10)
        let viewModel = factory.create(from: data)
        XCTAssertEqual(viewModel.todaysExpenseProgress, 1)
    }
    
}
