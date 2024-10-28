//
//  AnimationBootCamp.swift
//  Buttons
//
//  Created by arpit verma on 26/10/24.
//

import SwiftUI

struct AnimationBootCamp: View {
    @State var isshowAnimation : Bool = false
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 3)) {
                isshowAnimation.toggle()
            }
           
        }, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        RoundedRectangle(cornerRadius: 15)
            .frame(width: isshowAnimation ? 50:100,
                   height: isshowAnimation ? 50: 100
            ).rotationEffect(Angle(degrees: isshowAnimation ?360:0))
    }
}

#Preview {  
    AnimationBootCamp()
}
