//
//  ExpenseListInteractor.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol ExpenseListInteractorDelegate: class {
    
    func interactorDidFetch(expenses: [Expense])
    
}

protocol IExpenseListInteractor: class {
    
    var delegate: ExpenseListInteractorDelegate? { get set }
    func fetchExpenses()
    func delete(expense: Expense)
    func add(expense: Expense)
    
}

final class ExpenseListInteractor: IExpenseListInteractor {
    
    weak var delegate: ExpenseListInteractorDelegate?
    private let repository: ILocalRepository
    
    init(repository: ILocalRepository = LocalRepository()) {
        self.repository = repository
        subscribeRepositoryChanges()
    }
    
    private func subscribeRepositoryChanges() {
        repository.onChange = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.interactorDidFetch(expenses: strongSelf.repository.expenses)
        }
    }
    
    func fetchExpenses() {
        let expenses = repository.expenses
        delegate?.interactorDidFetch(expenses: expenses)
    }
    
    func delete(expense: Expense) {
        repository.delete(expense: expense)
    }
    
    func add(expense: Expense) {
        repository.add(expense: expense)
    }
    
}
