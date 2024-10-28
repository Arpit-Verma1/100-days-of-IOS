//
//  ContentView.swift
//  Buttons
//
//  Created by arpit verma on 25/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var title: String = "This is title"
    var body: some View {
        Text(title)
        Button("press me "){
            self.title = "button was pressed"
        }.accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        
        Button(action:{
            self.title="button 2 was pressed"
        },label: {
            Text("save".uppercased()
            ).font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal,15)
                .background(Color.blue.cornerRadius(10)
                    .shadow(radius: 10))
        })
        
        Button(action:{
            self.title="button 3 prressed"
        },label:{
            
            Circle().fill(Color.blue)
                .frame(width:75, height:75)
                .shadow(radius: 20)
                .overlay(Image(systemName: "heart.fill").foregroundColor(.red))
            
        }
               
               
        )
        
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                .font(.caption)
                .bold()
                .foregroundColor(.red)
                .padding()
                .padding(.horizontal,10)
                .background(Capsule().stroke(lineWidth: 2))
        })
        
    }
}

#Preview {
    ContentView()
}
