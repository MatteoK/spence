//
//  ViewModel.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct ViewModel {
    
    let sections: [Section]
    
    static func create(showButtons: Bool) -> ViewModel {
        let buttons = ButtonAmount.all.map({ CellType.button($0) })
        return ViewModel(sections: [
            Section(type: .top, cells: [.progressBar]),
            Section(type: .bottom, cells: [.dailySpending, .monthlySpending] + buttons)
            ])
    }
    
}
