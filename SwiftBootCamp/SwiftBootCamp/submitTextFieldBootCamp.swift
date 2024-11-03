//
//  submitTextFieldBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct submitTextFieldBootCamp: View {
    @State var textFieldState : String = ""
    var body: some View {
        TextField(text: $textFieldState, label: {
            Text("type yout password")
        })
        .onSubmit {
            print("button is pressed")
        }
        .submitLabel(.done)
    }
}

#Preview {
    submitTextFieldBootCamp()
}
