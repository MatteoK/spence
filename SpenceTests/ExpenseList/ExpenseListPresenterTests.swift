//
//  ExpenseListPresenterTests.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

final class ExpenseListPresenterTests: XCTestCase {
    
    var presenter: ExpenseListPresenter!
    private let view = MockView()
    private let interactor  = MockInteractor()
    private let sectionFactory = MockSectionFactory()
    
    override func setUp() {
        super.setUp()
        presenter = ExpenseListPresenter(view: view, interactor: interactor, sectionFactory: sectionFactory)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_whenViewDidLoad_thenAsksInteractorToFetchExpenses() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.fetchExpensesWasCalled)
    }
    
    func test_whenInteractorDidFetchExpenses_thenUpdatesViewWithViewModelFromFactory() {
        let expense = Expense(date: Date(), value: 22)
        presenter.interactorDidFetch(expenses: [expense])
        XCTAssertEqual(sectionFactory.expenses ?? [], [expense])
        XCTAssertEqual(view.viewModel?.sections ?? [], sectionFactory.result)
    }
    
    func test_whenDeleteItemIsPressed_thenAsksInteractorToDeleteCorrectExpense() {
        presenter.interactorDidFetch(expenses: [])
        presenter.deleteButtonPressedForItem(section: 1, row: 1)
        XCTAssertEqual(interactor.expenseToDelete, sectionFactory.domainResult[1].expenses[1])
    }
    
}

extension ExpenseListPresenterTests {
    
    class MockView: IExpenseListView {
        
        var viewModel: ExpenseListViewModel?
        
        func show(viewModel: ExpenseListViewModel) {
            self.viewModel = viewModel
        }
        
    }
    
    class MockInteractor: IExpenseListInteractor {
        
        var delegate: ExpenseListInteractorDelegate?
        var fetchExpensesWasCalled = false
        var expenseToDelete: Expense?
        
        func fetchExpenses() {
            fetchExpensesWasCalled = true
        }
        
        func delete(expense: Expense) {
            expenseToDelete = expense
        }
        
    }
    
    class MockSectionFactory: IExpenseListSectionViewModelFactory {
        
        var groupingType: ExpenseListSectionGroupingType = .day
        var expenses: [Expense]?
        let result = [
            ExpenseListSectionViewModel(
                title: "June 1990",
                items: [
                    ExpenseListItemViewModel(date: "19:22", value: "0"),
                    ExpenseListItemViewModel(date: "20:44", value: "1")
                ]
            ),
            ExpenseListSectionViewModel(
                title: "June 2017",
                items: [
                    ExpenseListItemViewModel(date: "22:40", value: "0"),
                    ExpenseListItemViewModel(date: "20:22", value: "1")
                ]
            )
        ]
        
        let domainResult = [
            ExpenseListSection(
                firstDate: Date(),
                expenses: [
                    Expense(date: Date(), value: 0),
                    Expense(date: Date(), value: 1)
                ]
            ),
            ExpenseListSection(
                firstDate: Date(),
                expenses: [
                    Expense(date: Date(), value: 2),
                    Expense(date: Date(), value: 3)
                ]
            )
        ]
        
        func create(from expenses: [Expense]) -> [ExpenseListSectionViewModel] {
            self.expenses = expenses
            return result
        }
        
        func createDomainModelSections(from expenses: [Expense]) -> [ExpenseListSection] {
            return domainResult
        }
        
    }
    
}
