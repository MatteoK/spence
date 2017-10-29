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
    func changeBudgetSelected(value: Int)
    
}

final class OverviewPresenter: IOverviewPresenter {
    
    fileprivate weak var view: IOverviewView?
    private let interactor: IOverviewInteractor
    fileprivate let viewModelFactory: IOverviewViewModelFactory
    fileprivate var overviewData: OverviewData?
    
    init(view: IOverviewView, interactor: IOverviewInteractor = OverviewInteractor(), viewModelFactory: IOverviewViewModelFactory = OverViewViewModelFactory()) {
        self.view = view
        self.interactor = interactor
        self.viewModelFactory = viewModelFactory
        self.interactor.delegate = self
    }
    
    func viewDidLoad() {
        interactor.fetchData()
    }
    
    func changeBudgetSelected(value: Int) {
        interactor.updateMonthlyBudget(to: value)
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
