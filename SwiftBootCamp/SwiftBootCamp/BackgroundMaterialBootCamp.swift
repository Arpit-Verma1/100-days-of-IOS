//
//  BackgroundMaterialBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct BackgroundMaterialBootCamp: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 50,height: 4)
                    .padding()
                Spacer()
            }
            .frame(
                height:350)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            
        }
        .ignoresSafeArea()
        .background(Image("arpit"))
    }
}

#Preview {
    BackgroundMaterialBootCamp()
}
