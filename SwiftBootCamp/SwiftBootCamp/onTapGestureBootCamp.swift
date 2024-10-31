//
//  onTapGestureBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct onTapGestureBootCamp: View {
    @State var isSelect : Bool = false
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width:.infinity,
                    height:100)
                .foregroundColor(isSelect ? .red : .green)
            
            Text("tap me")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)	
                .cornerRadius(10)
                .onTapGesture(count: 3, perform: {
                    isSelect.toggle()
                })
            Spacer()
        }.padding()
    }
}

#Preview {
    onTapGestureBootCamp()
}
