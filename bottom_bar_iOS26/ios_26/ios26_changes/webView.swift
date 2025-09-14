//
//  webView.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI
import WebKit

struct webView: View {
    @State private var page = WebPage()
    var body: some View {
        WebView(page)
            .webViewMagnificationGestures(.disabled)
            .onAppear {
                page.load(URLRequest(url: url))
                
            }
    }
    var url : URL {
        URL(string : "https://developer.appple.com")!
    }
    
}

#Preview {
    webView()
}
