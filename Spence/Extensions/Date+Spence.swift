//
//  Date+Spence.swift
//  Spence
//
//  Created by Matteo Koczorek on 10/28/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

extension Date {
    
    static func with(minute: Int = 0, hour: Int = 0, day: Int = 1, month: Int = 1, year: Int = 1990) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "mmHHddMMyyyy"
        return formatter.date(from: "\(minute.stringWithLeadingZeroes)\(hour.stringWithLeadingZeroes)\(day.stringWithLeadingZeroes)\(month.stringWithLeadingZeroes)\(year)")!
    }
    
}
