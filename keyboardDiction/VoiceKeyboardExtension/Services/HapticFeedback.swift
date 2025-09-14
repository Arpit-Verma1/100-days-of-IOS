//
//  HapticFeedback.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import UIKit

// MARK: - Haptic Feedback Protocol
protocol HapticFeedbackProtocol {
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
    func selection()
}

// MARK: - Haptic Feedback Implementation
class HapticFeedback: HapticFeedbackProtocol {
    
    // MARK: - Properties
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private var notificationGenerator: UINotificationFeedbackGenerator?
    private var selectionGenerator: UISelectionFeedbackGenerator?
    
    // MARK: - Impact Feedback
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = getImpactGenerator(for: style)
        generator.impactOccurred()
    }
    
    // MARK: - Notification Feedback
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = getNotificationGenerator()
        generator.notificationOccurred(type)
    }
    
    // MARK: - Selection Feedback
    func selection() {
        let generator = getSelectionGenerator()
        generator.selectionChanged()
    }
    
    // MARK: - Private Methods
    private func getImpactGenerator(for style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
        if let generator = impactGenerators[style] {
            return generator
        } else {
            let generator = UIImpactFeedbackGenerator(style: style)
            impactGenerators[style] = generator
            return generator
        }
    }
    
    private func getNotificationGenerator() -> UINotificationFeedbackGenerator {
        if let generator = notificationGenerator {
            return generator
        } else {
            let generator = UINotificationFeedbackGenerator()
            notificationGenerator = generator
            return generator
        }
    }
    
    private func getSelectionGenerator() -> UISelectionFeedbackGenerator {
        if let generator = selectionGenerator {
            return generator
        } else {
            let generator = UISelectionFeedbackGenerator()
            selectionGenerator = generator
            return generator
        }
    }
}
