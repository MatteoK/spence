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
    private let budgetOptionsViewModelFactory = MockBudgetOptionsViewModelFactory()
    
    override func setUp() {
        super.setUp()
        presenter = OverviewPresenter(view: view, interactor: interactor, viewModelFactory: viewModelFactory, budgetOptionsViewModelFactory: budgetOptionsViewModelFactory)
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
    
    func test_whenChangeBudgetButtonPressed_thenAsksViewToShowPickerViewWithOptionsViewModel() {
        presenter.interactorDidFetch(
            data: OverviewData(
                monthlyBudget: 99,
                todaysBudged: 0,
                thisMonthsExpenses: 0,
                todaysExpenses: 0)
        )
        presenter.changeBudgetButtonPressed()
        XCTAssertEqual(view.optionsViewModel, budgetOptionsViewModelFactory.result)
        XCTAssertEqual(budgetOptionsViewModelFactory.currentBudget, 99)
    }
    
    func test_whenDidPickBudgetAtIndex_thenInteractorIsAskedToUpdateMonthlyBudget() {
        presenter.didPickBudget(at: 3)
        XCTAssertEqual(interactor.updatedMonthlyBudget, BudgetOptionsProvider.options[3])
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
        var optionsViewModel: BudgetOptionsViewModel?
        
        func show(viewModel: OverviewViewModel) {
            self.viewModel = viewModel
        }
        
        func showBudgetPicker(viewModel: BudgetOptionsViewModel) {
            optionsViewModel = viewModel
        }
        
    }
    
    fileprivate final class MockFactory: IOverviewViewModelFactory {
        
        let result = OverviewViewModel(thisMonthsExpenseProgress: 1, todaysExpenseProgress: 1, todaysBudget: "a", monthlyBudget: "b", todaysExpenses: "c", thisMonthsExpenses: "d")
        var data: OverviewData?
        
        func create(from data: OverviewData) -> OverviewViewModel {
            self.data = data
            return result
        }
        
    }
    
    fileprivate final class MockBudgetOptionsViewModelFactory: IBudgetOptionsViewModelFactory {
        
        var currentBudget: Int?
        let result = BudgetOptionsViewModel(options: ["a", "b", "c"], selectedIndex: 0)
        
        func create(currentBudget: Int) -> BudgetOptionsViewModel {
            self.currentBudget = currentBudget
            return result
        }
        
    }
    
}
