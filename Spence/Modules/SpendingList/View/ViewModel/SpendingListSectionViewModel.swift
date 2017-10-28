//
//  SpendingListSection.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct SpendingListSectionViewModel {
    
    let title: String
    let items: [SpendingListItemViewModel]
    
}

extension SpendingListSectionViewModel: Equatable {}

func ==(lhs: SpendingListSectionViewModel, rhs: SpendingListSectionViewModel) -> Bool {
    return lhs.title == rhs.title && lhs.items == rhs.items
}
