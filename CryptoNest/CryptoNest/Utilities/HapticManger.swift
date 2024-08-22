//
//  HapticManger.swift
//  CryptoNest
//
//  Created by arpit verma on 22/08/24.
//

import Foundation

import SwiftUI

class HapticManger {
    static private let generator = UINotificationFeedbackGenerator()
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
