//
//  Double.swift
//  CryptoNest
//
//  Created by arpit verma on 07/08/24.
//

import Foundation

extension Double {
    private var currencyFormatters:NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    func asCurrencyWithDecials() -> String {
        let number = NSNumber(value: self)
        return currencyFormatters.string(from: number) ?? "0.00"
        
    }
    func asNumberString ()->String{
        return String (format: "%.2f", self)
    }
    func asPercentString()->String{
        return asNumberString() + "%"
    }
    
    
    func formattedWithAbbreviation() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            return sign + String(format: "%.2fB", formatted)
        case 1_000_000...:
            let formatted = num / 1_000_000
            return sign + String(format: "%.2fM", formatted)
        case 1_000...:
            let formatted = num / 1_000
            return sign + String(format: "%.2fK", formatted)
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
    }
}
