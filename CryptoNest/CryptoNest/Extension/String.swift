//
//  String.swift
//  CryptoNest
//
//  Created by arpit verma on 27/08/24.
//

import Foundation
extension String {
    var removingHtmlOccurences : String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
