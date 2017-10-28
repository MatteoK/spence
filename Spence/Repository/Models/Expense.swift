//
//  Expense.swift
//  Spence
//
//  Created by Matteo Koczorek on 9/4/17.
//  Copyright © 2017 Matteo Koczorek. All rights reserved.
//

import Foundation

struct Expense {
    
    let date: Date
    let value: Float
    
    static func from(string: String) -> Expense? {
        let split = string.components(separatedBy: "_")
        guard split.count == 2 else { return nil }
        let dateString = split[0]
        let valueString = split[1]
        guard let date = dateFormatter().date(from: dateString) else { return nil }
        let value = (valueString as NSString).floatValue
        return Expense(date: date, value: value)
    }
    
    func toString() -> String {
        return "\(dateString())_\(valueString())"
    }
    
    private func dateString() -> String {
        return Expense.dateFormatter().string(from: date)
    }
    
    private func valueString() -> String {
        return "\(value)"
    }
    
    private static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat()
        return dateFormatter
    }
    
    private static func dateFormat() -> String {
        return "ddMMyyyyHHmmssSSS"
    }
    
}

extension Expense: Equatable {}

func ==(lhs: Expense, rhs: Expense) -> Bool {
    return lhs.toString() == rhs.toString()
}
