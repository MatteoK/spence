//
//  SpendingListInteractor.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/16/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol SpendingListInteractorDelegate: class {
    
    func interactorDidFetch(spendings: [Spending])
    
}

protocol ISpendingListInteractor: class {
    
    func fetchSpendings()
    var delegate: SpendingListInteractorDelegate? { get set }
    
}

final class SpendingListInteractor: ISpendingListInteractor {
    
    weak var delegate: SpendingListInteractorDelegate?
    private let repository: ILocalRepository
    
    init(repository: ILocalRepository = LocalRepository()) {
        self.repository = repository
    }
    
    func fetchSpendings() {
        let spendings = repository.spendings
        delegate?.interactorDidFetch(spendings: spendings)
    }
    
}
