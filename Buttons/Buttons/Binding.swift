//
//  Binding.swift
//  Buttons
//
//  Created by arpit verma on 26/10/24.
//

import SwiftUI

struct BindingBootCamp: View {
    @State var backgroundColor: Color = .pink
    @State var title : String = "this is title"
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            ButtonView(backgroundColor: $backgroundColor)
        }
        
    }
}

struct ButtonView : View {
    @Binding var backgroundColor: Color
    @State var buttonColor: Color = Color.blue
    var body: some View {
        Button(action: {
            backgroundColor = Color.yellow
            buttonColor = Color.green
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/.padding().background(
                buttonColor).foregroundColor(.white).cornerRadius(10)
        })
        
    }
}

#Preview {
    BindingBootCamp()
}
