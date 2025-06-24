//
//  tabView.swift
//  ios_26
//
//  Created by Arpit Verma on 6/24/25.
//

import SwiftUI

struct tabView: View {
    var body: some View {
        TabView {
            Tab.init("Home", systemImage: "house.fill")
            {
              
                ScrollView(.vertical) {
                    Text("Home")
                        .containerRelativeFrame([.horizontal])
                        .containerRelativeFrame(.vertical ){ value , _ in
                            value*2
                            
                        }
                }
            }
            Tab.init("Favourite", systemImage: "suit.heart.fill")
            {
                Text("Home")
            }
            Tab.init("Setting", systemImage: "gearshape.fill")
            {
                Text("Home")
            }
        }
        .tabViewBottomAccessory {
            Text("Custom Music Player")
                .padding(.horizontal,15)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    tabView()
}
