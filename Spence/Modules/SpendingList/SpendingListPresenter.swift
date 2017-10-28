//
//  SpendingListPresenter.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol ISpendingListPresenter: class {
    
    func viewDidLoad()
    
}

final class SpendingListPresenter: ISpendingListPresenter {
    
    fileprivate let interactor: ISpendingListInteractor
    fileprivate weak var view: ISpendingListView?
    fileprivate let sectionFactory: ISpendingListSectionViewModelFactory
    
    init(view: ISpendingListView,
         interactor: ISpendingListInteractor = SpendingListInteractor(),
         sectionFactory: ISpendingListSectionViewModelFactory = SpendingListSectionViewModelFactory()) {
        self.interactor = interactor
        self.view = view
        self.sectionFactory = sectionFactory
        interactor.delegate = self
    }
    
    func viewDidLoad() {
        interactor.fetchSpendings()
    }
    
}

extension SpendingListPresenter: SpendingListInteractorDelegate {
    
    func interactorDidFetch(spendings: [Spending]) {
        view?.show(viewModel: viewModel(from: spendings))
    }
    
    private func viewModel(from spendings: [Spending]) -> SpendingListViewModel {
        let sections = sectionFactory.create(from: spendings)
        return SpendingListViewModel(sections: sections)
    }
    
}
