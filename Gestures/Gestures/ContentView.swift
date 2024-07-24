//
//  ContentView.swift
//  Gestures
//
//  Created by arpit verma on 24/07/24.
//

import SwiftUI

struct ContentView: View {
    @GestureState  var isLongPressed = false
    var body: some View {
        let longpressgesure = LongPressGesture().updating($isLongPressed, body: { (value, state, transaction) in
            state = value
        })
        VStack{
            Circle()
                .fill(isLongPressed ? Color.red : Color.green)
                .frame(width: 200, height: 200)
                .gesture(isLongPressed ? nil : longpressgesure)
        }
                                                          
    }
}

#Preview {
    ContentView()
}
