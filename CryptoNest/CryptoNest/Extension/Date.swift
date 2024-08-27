//
//  Date.swift
//  CryptoNest
//
//  Created by arpit verma on 27/08/24.
//

import Foundation

extension Date {
    
    init (coingeckoString : String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: coingeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    
    private var shortFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString () -> String {
        return shortFormatter.string(from: self)
    }
    
}
