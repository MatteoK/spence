//
//  ButtonAmount.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/2/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

enum ButtonAmount: Int {
    
    case one, two, three, five
    
    var value: Float {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .five:
            return 5
        }
    }
    
    static var all: [ButtonAmount] = [.one, .two, .three, .five]
    
}
