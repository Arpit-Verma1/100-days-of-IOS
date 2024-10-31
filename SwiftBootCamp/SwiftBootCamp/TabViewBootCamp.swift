//
//  TabViewBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct TabViewBootCamp: View {
    @State var selectedTab : Int = 3
    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            ZStack{
                Color.red.ignoresSafeArea()
                VStack{
                    Text("homepage")
                }
            }
            .tabItem { 
                Text("home")
                 Image(systemName: "house.fill")
            }
            .tag(0)
            Text("Tab Content 2").tabItem { Text("setting")
                Image(systemName: "gear") }.tag(1)
        })
//        .tabViewStyle(.page)
        .accentColor(.green)
//        .appearance(Color:.green)
    }
}

#Preview {
    TabViewBootCamp()
}
