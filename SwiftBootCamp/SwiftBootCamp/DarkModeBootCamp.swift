//
//  DarkModeBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct DarkModeBootCamp: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView{
            ScrollView{
                Text("primaryColor").foregroundColor(.primary)
                Text("secondColor").foregroundColor(.secondary)
                Text("adaptive").foregroundColor(Color("adaptive"))
                Text("localadaptive").foregroundColor(colorScheme == .light ? .green : .yellow)
            }
            .navigationTitle("DarkMODE ")
        }
        
    }
}

#Preview {
    DarkModeBootCamp()
}
