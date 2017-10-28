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
        
        func fetchExpenses() {
            fetchExpensesWasCalled = true
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
            )
        ]
        
        func create(from expenses: [Expense]) -> [ExpenseListSectionViewModel] {
            self.expenses = expenses
            return result
        }
        
    }
    
}
