//
//  ContentView.swift
//  chatBot
//
//  Created by Arpit Verma on 7/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            DocumentManagementView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Documents")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
