//
//  safeAreaInsetsBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct safeAreaInsetsBootCamp: View {
    var body: some View {
        NavigationStack  {
            List(0..<10) {
                _ in
                Rectangle()
                    .frame(height: 100)
            }
            .navigationTitle("safearea inset")
//            .overlay(Text("hi")
//                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                .background(Color.yellow),
//                     alignment: .bottom
//                     
//            )
            .safeAreaInset(edge: .top,spacing: nil) {
                Text("hi")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .background(Color.yellow)
            }
        }
    }
}

#Preview {
    safeAreaInsetsBootCamp()
}
