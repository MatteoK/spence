//
//  OverviewInteractorTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class OverviewInteractorTests: XCTestCase {
    
    private var interactor: OverviewInteractor!
    private let repository = MockRepository()
    private let delegate = Delegate()
    
    override func setUp() {
        super.setUp()
        interactor = OverviewInteractor(repository: repository)
        interactor.delegate = delegate
    }
    
    func test_whenFetchDataIsCalled_thenUpdatesDelegateWithDataFromRepository() {
        interactor.fetchData()
        XCTAssertEqual(delegate.data?.monthlyBudget, 100)
        XCTAssertEqual(delegate.data?.thisMonthsExpenses, 10)
        XCTAssertEqual(delegate.data?.todaysBudged, 10)
        XCTAssertEqual(delegate.data?.todaysExpenses, 2)
    }
    
    func test_whenUpdateBudgetIsCalled_thenBudgetIsUpdatedInRepositoryAndDelegateIsNotified() {
        interactor.updateMonthlyBudget(to: 33)
        XCTAssertEqual(repository.monthlyBudget, 33)
        XCTAssertEqual(delegate.data?.monthlyBudget, 33)
    }
    
}

extension OverviewInteractorTests {
    
    fileprivate final class MockRepository: ILocalRepository {
        
        var monthlyBudget: Float = 100
        var todaysExpenses: Float = 2
        func addToTodaysExpenses(value: Float) {}
        var thisMonthsExpenses: Float = 10
        var percentSpentToday: Float = 0
        var todaysBudget: Float = 10
        var expenses: [Expense] = []
        
    }
    
    fileprivate final class Delegate: OverviewViewInteractorDelegate {
        
        var data: OverviewData?
        
        func interactorDidFetch(data: OverviewData) {
            self.data = data
        }
        
    }
    
}
