//
//  OverviewInteractor.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol OverviewViewInteractorDelegate: class {
    
    func interactorDidFetch(data: OverviewData)
    
}

protocol IOverviewInteractor: class {
    
    var delegate: OverviewViewInteractorDelegate? { get set }
    func fetchData()
    func updateMonthlyBudget(to value: Int)
    
}

final class OverviewInteractor: IOverviewInteractor {
    
    weak var delegate: OverviewViewInteractorDelegate?
    let repository: ILocalRepository
    
    init(repository: ILocalRepository = LocalRepository()) {
        self.repository = repository
        subscribeRepositoryChanges()
    }
    
    private func subscribeRepositoryChanges() {
        repository.onChange = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.interactorDidFetch(data: strongSelf.dataFromRepository())
        }
    }
    
    func fetchData() {
        delegate?.interactorDidFetch(data: dataFromRepository())
    }
    
    private func dataFromRepository() -> OverviewData {
        return OverviewData(
            monthlyBudget: Int(repository.monthlyBudget),
            todaysBudged: Int(repository.todaysBudget),
            thisMonthsExpenses: Int(repository.thisMonthsExpenses),
            todaysExpenses: Int(repository.todaysExpenses)
        )
    }
    
    func updateMonthlyBudget(to value: Int) {
        repository.monthlyBudget = Float(value)
        delegate?.interactorDidFetch(data: dataFromRepository())
    }
    
}
