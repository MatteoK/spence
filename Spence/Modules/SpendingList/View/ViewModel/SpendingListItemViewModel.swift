//
//  SpendingListItem.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct SpendingListItemViewModel {
    
    let date: String
    let value: String
    
}

extension SpendingListItemViewModel: Equatable {}

func ==(lhs: SpendingListItemViewModel, rhs: SpendingListItemViewModel) -> Bool {
    return lhs.date == rhs.date && lhs.value == rhs.value
}
