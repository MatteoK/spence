//
//  AmountQueue.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IAmountQueue {
    
    var enqueuedAmount: Float { get }
    func enqueue(amount: Float)
    func clear()
    func commit()
    
}

final class AmountQueue: IAmountQueue {
    
    let localRepository: ILocalRepository
    var enqueuedAmount: Float = 0
    
    init(localRepository: ILocalRepository = LocalRepository()) {
        self.localRepository = localRepository
    }
    
    func enqueue(amount: Float) {
        enqueuedAmount += amount
    }
    
    func clear() {
        enqueuedAmount = 0
    }
    
    func commit() {
        localRepository.addToTodaysSpendings(value: enqueuedAmount)
        clear()
    }
    
}
