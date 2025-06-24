//
//  backgroundExtensionEffect.swift
//  ios_26
//
//  Created by Arpit Verma on 24/06/25.
//

import SwiftUI

struct backgroundExtensionEffect: View {
    @State private var showSheet = false
    var body: some View {
        
        GeometryReader {
            let size = $0.size
            Image(systemName: "house.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
                .backgroundExtensionEffect()
            
        }
    }
}

#Preview {
    backgroundExtensionEffect()
}
