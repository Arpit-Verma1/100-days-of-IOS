//
//  LotieView.swift
//  LottieAnimation
//
//  Created by arpit verma on 23/07/24.
//

import Lottie
import SwiftUI
import UIKit
struct LottieView : UIViewRepresentable{
    typealias UIViewType = UIView
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named("loading")
//        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        <#code#>//
    }
}

