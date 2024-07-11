//
//  ContentView.swift
//  AlertsSwiftUi
//
//  Created by arpit verma on 11/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var alertPresented =  false;
    var body: some View {
        VStack {
            Button(action:{
                self.alertPresented=true;
            } ,label: {Text("tap me")}).frame(
            width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/
            ,
            height: 200,
            alignment : .center
            ).padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/).background(
                Color.red).cornerRadius(10)
        }.navigationTitle("alerts").alert(isPresented: $alertPresented, content: {
            Alert(title: Text("Alert Title"), message: Text("Alert Body"),dismissButton: .default(Text("Button Text")))
        })

    }
}

#Preview {
    ContentView()
}
