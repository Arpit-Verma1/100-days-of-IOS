//
//  ColorPickerBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 29/10/24.
//

import SwiftUI

struct ColorPickerBootCamp: View {
    @State var backgroundColor : Color = .green
    var body: some View {
        ZStack{
            backgroundColor.ignoresSafeArea()
            
            ColorPicker(selection: $backgroundColor, supportsOpacity: true, label: {Text("Choose color")})
                .padding()
            
                .background(.blue)
                .cornerRadius(10)
                .padding()
                
        }
    }
}

#Preview {
    ColorPickerBootCamp()
}
