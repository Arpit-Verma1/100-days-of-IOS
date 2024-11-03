//
//  animationUpdatedBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct animationUpdatedBootCamp: View {
    @State var animate1: Bool = false
    @State var animate2: Bool = false
    var body: some View {
        ZStack{
            VStack{
                Button(action: {
                    animate1.toggle()
                }, label: {Text("b1")})
                Button(action: {
                    animate2.toggle()
                }, label: {Text("b2")})
                ZStack{
                    
                    Rectangle()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
                        .frame(maxWidth: 0,alignment: animate1 ? .leading : .trailing)
                        .background(.green)
                        .frame(maxHeight: .infinity,alignment: animate2 ? .top : .bottom)
                        .background(Color.orange
                        )
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity)
                .background(Color.red)
            }
        }
        .animation(.spring,value: animate1)
        .animation(.linear,value: animate2)
    }
}

#Preview {
    animationUpdatedBootCamp()
}
