//
//  ExpenseListInteractorTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

final class ExpenseListInteractorTests: XCTestCase {
    
    private var interactor: ExpenseListInteractor!
    private let repository = MockRepository()
    private let delegate = Delegate()
    
    override func setUp() {
        super.setUp()
        interactor = ExpenseListInteractor(repository: repository)
        interactor.delegate = delegate
    }
    
    func test_whenFetchExpensesIsCalled_thenUpdatesDelegateWithExpensesFromRepository() {
        let expenses = [Expense(date: Date(), value: 21)]
        repository.expenses = expenses
        interactor.fetchExpenses()
        XCTAssertEqual(delegate.expenses ?? [], expenses)
    }
    
}

extension ExpenseListInteractorTests {
    
    final class MockRepository: ILocalRepository {
        
        var monthlyBudget: Float =  0
        var todaysExpenses: Float = 0
        func addToTodaysExpenses(value: Float) {}
        var thisMonthsExpenses: Float = 0
        var percentSpentToday: Float = 0
        var todaysBudget: Float = 0
        var expenses: [Expense] = []
        
    }
    
    final class Delegate: ExpenseListInteractorDelegate {
        
        var expenses: [Expense]?
        
        func interactorDidFetch(expenses: [Expense]) {
            self.expenses = expenses
        }
        
    }
    
}
