//
//  popOverBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct popOverBootCamp: View {
    @State var showPopOver : Bool = false
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea()
            Button(action: {
                showPopOver.toggle()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            .popover(isPresented: $showPopOver, content: {
                Text("hi there").presentationCompactAdaptation(.popover)
            })
            
        }
        
    }
}

#Preview {
    popOverBootCamp()
}
