//
//  KeyboardViewController.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private var keyboardHostingController: KeyboardViewHostingController!
    private var viewModel: KeyboardViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestMicrophonePermission()
    }
    
    // MARK: - Setup
    private func setupKeyboard() {
        viewModel = KeyboardViewModel(textDocumentProxy: SystemTextDocumentProxy(proxy: textDocumentProxy))
        
        let keyboardSwiftUIView = KeyboardView(viewModel: viewModel)
        keyboardHostingController = KeyboardViewHostingController(rootView: keyboardSwiftUIView)
        
        addChild(keyboardHostingController)
        view.addSubview(keyboardHostingController.view)
        keyboardHostingController.didMove(toParent: self)
        
        // Setup constraints
        keyboardHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardHostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SwiftUI Hosting Controller
class KeyboardViewHostingController: UIHostingController<KeyboardView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
