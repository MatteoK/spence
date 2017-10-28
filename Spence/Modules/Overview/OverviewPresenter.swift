//
//  OverviewPresenter.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IOverviewPresenter: class {
    
    func viewDidLoad()
    func changeBudgetButtonPressed()
    func didPickBudget(at index: Int)
    
}

final class OverviewPresenter: IOverviewPresenter {
    
    fileprivate weak var view: IOverviewView?
    private let interactor: IOverviewInteractor
    fileprivate let viewModelFactory: IOverviewViewModelFactory
    private let budgetOptionsViewModelFactory: IBudgetOptionsViewModelFactory
    fileprivate var overviewData: OverviewData?
    
    init(view: IOverviewView, interactor: IOverviewInteractor = OverviewInteractor(), viewModelFactory: IOverviewViewModelFactory = OverViewViewModelFactory(), budgetOptionsViewModelFactory: IBudgetOptionsViewModelFactory = BudgetOptionsViewModelFactory()) {
        self.view = view
        self.interactor = interactor
        self.viewModelFactory = viewModelFactory
        self.budgetOptionsViewModelFactory = budgetOptionsViewModelFactory
        self.interactor.delegate = self
    }
    
    func viewDidLoad() {
        interactor.fetchData()
    }
    
    func changeBudgetButtonPressed() {
        let budget = overviewData?.monthlyBudget ?? 0
        let viewModel = budgetOptionsViewModelFactory.create(currentBudget: budget)
        view?.showBudgetPicker(viewModel: viewModel)
    }
    
    func didPickBudget(at index: Int) {
        interactor.updateMonthlyBudget(to: BudgetOptionsProvider.options[index])
    }
    
}

extension OverviewPresenter: OverviewViewInteractorDelegate {
    
    func interactorDidFetch(data: OverviewData) {
        overviewData = data
        view?.show(viewModel: viewModel(from: data))
    }
    
    private func viewModel(from data: OverviewData) -> OverviewViewModel {
        return viewModelFactory.create(from: data)
    }
    
}
