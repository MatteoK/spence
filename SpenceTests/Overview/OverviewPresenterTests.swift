//
//  OverviewPresenterTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

final class OverviewPresenterTests: XCTestCase {
    
    private var presenter: OverviewPresenter!
    private let interactor = MockInteractor()
    private let viewModelFactory = MockFactory()
    private let view = MockView()
    
    override func setUp() {
        super.setUp()
        presenter = OverviewPresenter(
            view: view,
            interactor: interactor,
            viewModelFactory: viewModelFactory)
    }
    
    func test_whenViewDidLoadIsCalled_thenAsksInteractorToFetchData() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.fetchDataWasCalled)
    }
    
    func test_whenInteractorDidFetchData_thenViewIsCalledWithViewModelFromFactory() {
        let data = OverviewData(monthlyBudget: 1, todaysBudged: 2, thisMonthsExpenses: 3, todaysExpenses: 4)
        presenter.interactorDidFetch(data: data)
        XCTAssertEqual(viewModelFactory.data, data)
        XCTAssertEqual(view.viewModel, viewModelFactory.result)
    }
    
    func test_whenChangeBudgetSelected_thenAsksInteractorToChangeBudget() {
        presenter.changeBudgetSelected(value: 50)
        XCTAssertEqual(interactor.updatedMonthlyBudget, 50)
    }
    
}

extension OverviewPresenterTests {
    
    fileprivate final class MockInteractor: IOverviewInteractor {
        
        var fetchDataWasCalled = false
        var updatedMonthlyBudget = 0
        
        var delegate: OverviewViewInteractorDelegate?
        
        func fetchData() {
            fetchDataWasCalled = true
        }
        
        func updateMonthlyBudget(to value: Int) {
            updatedMonthlyBudget = value
        }
        
    }
    
    fileprivate final class MockView: IOverviewView {
        
        var viewModel: OverviewViewModel?
        
        func show(viewModel: OverviewViewModel) {
            self.viewModel = viewModel
        }
        
    }
    
    fileprivate final class MockFactory: IOverviewViewModelFactory {
        
        let result = OverviewViewModel(
            thisMonthsExpenseProgress: 1,
            todaysExpenseProgress: 1,
            todaysBudget: "a",
            monthlyBudget: "b",
            todaysExpenses: "c",
            thisMonthsExpenses: "d",
            monthlyBudgetValue: 3)
        var data: OverviewData?
        
        func create(from data: OverviewData) -> OverviewViewModel {
            self.data = data
            return result
        }
        
    }
    
}
