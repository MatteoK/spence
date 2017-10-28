//
//  Int+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

extension Int {
    
    var stringWithLeadingZeroes: String {
        return String(format: "%02d", self)
    }
    
}
