//
//  ExpenseListPresenter.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IExpenseListPresenter: class {
    
    func viewDidLoad()
    
}

final class ExpenseListPresenter: IExpenseListPresenter {
    
    fileprivate let interactor: IExpenseListInteractor
    fileprivate weak var view: IExpenseListView?
    fileprivate let sectionFactory: IExpenseListSectionViewModelFactory
    
    init(view: IExpenseListView,
         interactor: IExpenseListInteractor = ExpenseListInteractor(),
         sectionFactory: IExpenseListSectionViewModelFactory = ExpenseListSectionViewModelFactory()) {
        self.interactor = interactor
        self.view = view
        self.sectionFactory = sectionFactory
        interactor.delegate = self
    }
    
    func viewDidLoad() {
        interactor.fetchExpenses()
    }
    
}

extension ExpenseListPresenter: ExpenseListInteractorDelegate {
    
    func interactorDidFetch(expenses: [Expense]) {
        view?.show(viewModel: viewModel(from: expenses))
    }
    
    private func viewModel(from expenses: [Expense]) -> ExpenseListViewModel {
        let sections = sectionFactory.create(from: expenses)
        return ExpenseListViewModel(sections: sections)
    }
    
}
