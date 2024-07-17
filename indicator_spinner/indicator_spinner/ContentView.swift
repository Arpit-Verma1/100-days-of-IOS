//
//  ContentView.swift
//  indicator_spinner
//
//  Created by arpit verma on 17/07/24.
//
import ActivityIndicatorView
import SwiftUI

struct ContentView: View {
    @State var loading = false;
    var body: some View {
        VStack {
            ActivityIndicatorView(isVisible: $loading, type: .default(count: 8)).foregroundColor(.red).frame(
            width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
            height: 100
            
            ).padding()
            ActivityIndicatorView(isVisible: $loading, type: .equalizer(count: 5)).foregroundColor(.purple).frame(
            width: 100,
            height: 100
            
            ).padding()
            ActivityIndicatorView(isVisible: $loading, type: .rotatingDots(count: 7)).foregroundColor(.orange).frame(
            width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,
            height: 100
            
            ).padding()
            Button(action: {
                self.loading=true
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            }).frame(width: 200,height: 50).background(
                Color.blue).foregroundColor(.white).cornerRadius(15)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
