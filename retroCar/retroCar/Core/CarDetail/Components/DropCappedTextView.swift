//
//  DropCappedTextView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/19/26.
//

import SwiftUI


class DropCapLabel: UILabel {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let originalSize = super.sizeThatFits(size)
        return CGSize(width: originalSize.width, height: originalSize.height - 10.0)
    }
}


struct DropCappedTextView: UIViewRepresentable {
    private let firstCharacterFont = UIFont(name: "rolf", size: 45) ?? UIFont.systemFont(ofSize: 45)
    private let remainingFont = UIFont(name: "RM-Almanack", size: 40) ?? UIFont.systemFont(ofSize: 40)
    
    private var dropCap: String
    private var remainingText: String
    
    init(dropCap: String, remainingText: String) {
        self.dropCap = dropCap
        self.remainingText = remainingText
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = remainingText
        textView.font = remainingFont
        textView.backgroundColor = .clear
        
        let dropCapLabel = DropCapLabel()
        dropCapLabel.text = dropCap
        dropCapLabel.font = firstCharacterFont
        dropCapLabel.sizeToFit()
        textView.addSubview(dropCapLabel)
        textView.textContainer.exclusionPaths = [UIBezierPath(rect: dropCapLabel.frame)]
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<Self>) {
    }
}

