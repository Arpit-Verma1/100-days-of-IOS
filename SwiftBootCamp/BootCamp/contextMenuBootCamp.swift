//
//  contextMenuBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 28/10/24.
//

import SwiftUI

struct contextMenuBootCamp: View {
    @State var backgroundColor : Color = Color.blue
    var body: some View {
        VStack(alignment: .leading){
            Image(systemName:"house.fill")
            Text("this is text1")
            Text("this is text2")
        }.foregroundColor(.white)
           .padding(.all ,30)
           .background(backgroundColor.cornerRadius(20))
           .contextMenu(ContextMenu(menuItems: {
               Button(action: {
                   backgroundColor = .red
               }, label: {
                   Text("Button1")
               })
               Button(action: {
                   backgroundColor = .pink
               }, label: {
                   Text("button2")
               })
               Button(action: {
                   backgroundColor = .green
               }, label: {
                   Label(
                    title: { /*@START_MENU_TOKEN@*/Text("Label")/*@END_MENU_TOKEN@*/ },
                    icon: { /*@START_MENU_TOKEN@*/Image(systemName: "42.circle")/*@END_MENU_TOKEN@*/ }
                   )
               })
           }))
    }
}

#Preview {
    contextMenuBootCamp()
}
