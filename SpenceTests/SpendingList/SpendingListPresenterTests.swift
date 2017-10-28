//
//  SpendingListPresenterTests.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class SpendingListPresenterTests: XCTestCase {
    
    var presenter: SpendingListPresenter!
    private let view = MockView()
    private let interactor  = MockInteractor()
    private let sectionFactory = MockSectionFactory()
    
    override func setUp() {
        super.setUp()
        presenter = SpendingListPresenter(view: view, interactor: interactor, sectionFactory: sectionFactory)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_whenViewDidLoad_thenAsksInteractorToFetchSpendings() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.fetchSpendingsWasCalled)
    }
    
    func test_whenInteractorDidFetchSpendings_thenUpdatesViewWithViewModelFromFactory() {
        let spending = Spending(date: Date(), value: 22)
        presenter.interactorDidFetch(spendings: [spending])
        XCTAssertEqual(sectionFactory.spendings ?? [], [spending])
        XCTAssertEqual(view.viewModel?.sections ?? [], sectionFactory.result)
    }
    
}

extension SpendingListPresenterTests {
    
    class MockView: ISpendingListView {
        
        var viewModel: SpendingListViewModel?
        
        func show(viewModel: SpendingListViewModel) {
            self.viewModel = viewModel
        }
        
    }
    
    class MockInteractor: ISpendingListInteractor {
        
        var delegate: SpendingListInteractorDelegate?
        var fetchSpendingsWasCalled = false
        
        func fetchSpendings() {
            fetchSpendingsWasCalled = true
        }
        
    }
    
    class MockSectionFactory: ISpendingListSectionViewModelFactory {
        
        var groupingType: SpendingListSectionGroupingType = .day
        var spendings: [Spending]?
        let result = [
            SpendingListSectionViewModel(
                title: "June 1990",
                items: [
                    SpendingListItemViewModel(date: "19:22", value: "0"),
                    SpendingListItemViewModel(date: "20:44", value: "1")
                ]
            )
        ]
        
        func create(from spendings: [Spending]) -> [SpendingListSectionViewModel] {
            self.spendings = spendings
            return result
        }
        
    }
    
}
