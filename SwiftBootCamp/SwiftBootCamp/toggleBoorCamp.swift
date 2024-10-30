//
//  toggleBoorCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 28/10/24.
//

import SwiftUI

struct toggleBoorCamp: View {
    @State var toggleIson : Bool = true
    var body: some View {
        Toggle(
            isOn: $toggleIson, label: {
                Text("choose mode")
            }
        ).toggleStyle(SwitchToggleStyle(tint: .red))
    }
}

#Preview {
    toggleBoorCamp()
}
