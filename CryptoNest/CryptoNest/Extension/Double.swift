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
}
