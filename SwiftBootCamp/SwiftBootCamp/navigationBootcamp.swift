//
//  navigationBootcamp.swift
//  Buttons
//
//  Created by arpit verma on 27/10/24.
//

import SwiftUI

struct navigationBootcamp: View {
    var body: some View {
        NavigationView {
            
            ScrollView {
                Text("text 1")
                Text("text 2")
                Text("text 3")
            }
            .navigationTitle("first screen")
            .navigationBarItems(leading:NavigationLink( destination: Text("Second screen"),label: {
                Image(systemName: "gear")
            }), trailing: Image(systemName: "xmark"))
        }
    }
}

#Preview {
    navigationBootcamp()
}
