//
//  DateProvider.swift
//  Spence
//
//  Created by Matteo Koczorek on 8/26/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

protocol IDateProvider {
    
    func currentDate() -> Date
    
}

final class DateProvider: IDateProvider {
    
    func currentDate() -> Date {
        return Date()
    }
    
}
