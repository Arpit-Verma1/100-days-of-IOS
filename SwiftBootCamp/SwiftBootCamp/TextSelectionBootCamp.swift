//
//  TextSelectionBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 02/11/24.
//

import SwiftUI

struct TextSelectionBootCamp: View {
    var body: some View {
        VStack {
            Button("button title") {
                
            }
            .frame(height :55)
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
            
            Button("button title") {
                
            }
            .frame(height :55)
            .frame(maxWidth: .infinity)
            .controlSize(.large)
            .buttonStyle(.bordered)
            
            Button("button title") {
                
            }
            .frame(height :55)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            
            Button("button title") {
                
            }
            .frame(height :55)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderless)
        }
        .padding()
    }
}

#Preview {
    TextSelectionBootCamp()
}
