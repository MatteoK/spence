//
//  SpendingListInteractorTests.swift
//  SpenceTests
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import XCTest
@testable import Spence

class SpendingListInteractorTests: XCTestCase {
    
    private var interactor: SpendingListInteractor!
    private let repository = MockRepository()
    private let delegate = Delegate()
    
    override func setUp() {
        super.setUp()
        interactor = SpendingListInteractor(repository: repository)
        interactor.delegate = delegate
    }
    
    func test_whenFetchSpendingsIsCalled_thenUpdatesDelegateWithSpendingsFromRepository() {
        let spendings = [Spending(date: Date(), value: 21)]
        repository.spendings = spendings
        interactor.fetchSpendings()
        XCTAssertEqual(delegate.spendings ?? [], spendings)
    }
    
}

extension SpendingListInteractorTests {
    
    final class MockRepository: ILocalRepository {
        
        var monthlyBudget: Float =  0
        var todaysSpendings: Float = 0
        func addToTodaysSpendings(value: Float) {}
        var thisMonthsSpendings: Float = 0
        var percentSpentToday: Float = 0
        var todaysBudget: Float = 0
        var spendings: [Spending] = []
        
    }
    
    final class Delegate: SpendingListInteractorDelegate {
        
        var spendings: [Spending]?
        
        func interactorDidFetch(spendings: [Spending]) {
            self.spendings = spendings
        }
        
    }
    
}
