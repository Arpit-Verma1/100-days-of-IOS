//
//  popupBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 27/10/24.
//

import SwiftUI

struct popupBootCamp: View {
    @State var showSheet : Bool = false
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            
            Button(action: {
                showSheet.toggle()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            
            ///method 1
            //        .sheet(isPresented: $showSheet, content: {
            //            second()
            //        })
            //method -2
//            ZStack {
//                if showSheet {
//                    second(showsheet: $showSheet)
//                        .padding(.top, 20)
//                        .transition(.move(edge: .bottom))
//                }
//            }.zIndex(3)
            
        }
    }
}

struct second : View {
    @Binding var showsheet: Bool
    var body: some View {
        ZStack (alignment: .topLeading){
            Color.blue.ignoresSafeArea()
            Button(action: {
                print("Button tapped")
                showsheet.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white)
            })
        }
    }
    
}

#Preview {
    popupBootCamp()
}
