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
    private var repository: MockRepository!
    private var delegate: Delegate!
    
    override func setUp() {
        super.setUp()
        repository = MockRepository()
        delegate = Delegate()
        interactor = ExpenseListInteractor(repository: repository)
        interactor.delegate = delegate
    }
    
    func test_whenFetchExpensesIsCalled_thenUpdatesDelegateWithExpensesFromRepository() {
        interactor.fetchExpenses()
        XCTAssertEqual(delegate.expenses ?? [], repository.expenses)
    }
    
    func test_whenDeleteExpenseIsCalled_thenDeletesExpenseInRepository() {
        let expense = Expense(date: Date(), value: 4)
        interactor.delete(expense: expense)
        XCTAssertEqual(repository.expenseToDelete, expense)
    }
    
    func test_whenRepositoryChanges_thenDelegateIsNotified() {
        repository.onChange?()
        XCTAssertEqual(delegate.expenses ?? [], repository.expenses)
    }
    
    func test_whenAddExpenseIsCalled_thenAddsExpenseToRepository() {
        let expense = Expense(date: Date(), value: 11)
        interactor.add(expense: expense)
        XCTAssertEqual(repository.expenseToAdd, expense)
    }
    
}

extension ExpenseListInteractorTests {
    
    final class MockRepository: ILocalRepository {
        
        var expenseToDelete: Expense?
        var expenseToAdd: Expense?
        
        var monthlyBudget: Float =  0
        var todaysExpenses: Float = 0
        func addToTodaysExpenses(value: Float) {}
        var thisMonthsExpenses: Float = 0
        var percentSpentToday: Float = 0
        var todaysBudget: Float = 0
        var expenses: [Expense] = [Expense(date: Date(), value: 21)]
        var onChange: (() -> Void)?
        
        func add(expense: Expense) {
            expenseToAdd = expense
        }
        
        func delete(expense: Expense) {
            expenseToDelete = expense
        }
        
    }
    
    final class Delegate: ExpenseListInteractorDelegate {
        
        var expenses: [Expense]?
        
        func interactorDidFetch(expenses: [Expense]) {
            self.expenses = expenses
        }
        
    }
    
}
