//
//  SheetBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 26/10/24.
//

import SwiftUI

struct SheetBootCamp: View {
    @State var showsheet : Bool = false
    var body: some View {
        ZStack {	
            Color.green.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Button(action: {
                showsheet.toggle()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    .foregroundColor(.black)
                    .padding()
                    
                    .background(
                        Color.white)
                    .cornerRadius(10)
            })
            
        }
        .fullScreenCover(isPresented: $showsheet, content: {
            secondScreen()
        })
    }
}

struct secondScreen :View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        ZStack(alignment: .topLeading){
            Color.red.ignoresSafeArea()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
            })
        }
    }
}

#Preview {
    SheetBootCamp()
}
