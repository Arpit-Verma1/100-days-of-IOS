//
//  TextDocumentProxyAdapter.swift
//  keyboardDiction
//
//  Created by Arpit Verma on 9/1/25.
//

import Foundation
import UIKit

// MARK: - Abstraction for testability
protocol TextDocumentProxyProtocol {
    func insertText(_ text: String)
    func deleteBackward()
}

// MARK: - System adapter wrapping UITextDocumentProxy
struct SystemTextDocumentProxy: TextDocumentProxyProtocol {
    private weak var proxy: UITextDocumentProxy?
    
    init(proxy: UITextDocumentProxy) {
        self.proxy = proxy
    }
    
    func insertText(_ text: String) {
        proxy?.insertText(text)
    }
    
    func deleteBackward() {
        proxy?.deleteBackward()
    }
}


