//
//  BadgeBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct BadgeBootCamp: View {
    var body: some View {
        VStack{
            TabView() {
                Color.red.tabItem {
                    Image(systemName: "heart.fill")
                    Text("home") }
                .badge("new")
                Color.green.tabItem {
                    Image(systemName: "heart.fill")
                    Text("home")
                }
                Color.purple.tabItem { Image(systemName: "heart.fill") }
                
            }
            
            List {
                Text("hi").badge(15)
                Text("hello").badge("new item")
            }
            
        }
    }
}

#Preview {
    BadgeBootCamp()
}
