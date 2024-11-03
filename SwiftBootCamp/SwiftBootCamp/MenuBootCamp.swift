//
//  MenuBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct MenuBootCamp: View {
    var body: some View {
        Menu {
            Button {
                
            } label: {
            Text("b1")
                
            }
            Button {
                
            } label: {
            Text("b2")
                
            }

        } label: {
            Text("click me")
        }

    }
}

#Preview {
    MenuBootCamp()
}
