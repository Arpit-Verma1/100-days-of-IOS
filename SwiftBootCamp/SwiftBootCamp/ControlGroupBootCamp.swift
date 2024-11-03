//
//  ControlGroupBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 03/11/24.
//

import SwiftUI

struct ControlGroupBootCamp: View {
    var body: some View {
        Menu("my menu") {
            Button(action: {}, label: {Text("b1")})
            ControlGroup {
                Button(action: {}, label: {Text("b1")})
                Button(action: {}, label: {Text("b2")})
                Button(action: {}, label: {Text("b3")})
            } label: {
            Text("label1")
            }

        }
        
    }
}

#Preview {
    ControlGroupBootCamp()
}
