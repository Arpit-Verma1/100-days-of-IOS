//
//  focusStateBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct focusStateBootCamp: View {
    @State  var textFieldState : String = ""
    @State var isFocused : Bool = false
    
    var body: some View {
        VStack {
            TextField(text: $textFieldState, label: {
                Text("enter your password")
            })
            .focused(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=$isFocused@*/FocusState<Bool>().projectedValue/*@END_MENU_TOKEN@*/)
            Button(action: {
                isFocused.toggle()
            }, label: {
                Text("Button")
            })
        }
    }
}

#Preview {
    focusStateBootCamp()
}
