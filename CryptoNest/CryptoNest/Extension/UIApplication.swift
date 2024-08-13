//
//  UIApplication.swift
//  CryptoNest
//
//  Created by arpit verma on 13/08/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing (){
        sendAction(#selector(UIResponder.resignFirstResponder), to : nil, from : nil, for: nil)
    }
}
