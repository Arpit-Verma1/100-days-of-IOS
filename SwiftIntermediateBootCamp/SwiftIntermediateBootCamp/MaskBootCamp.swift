//
//  MaskBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 14/11/24.
//

import SwiftUI

struct MaskBootCamp: View {
    @State var rating : Int = 0
    var body: some View {
        ZStack{
            starsView.overlay(overlayView.mask(starsView))
        }
    }
    
    
    private var overlayView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: CGFloat(rating)/5*geometry.size.width)
            }
        }
    }
    
    private var starsView:some View {
        
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName:  "star.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.gray)
                        .onTapGesture {
                            withAnimation {
                                rating = index+1
                            }
                        }
                    
                }
            
        }
    }
    
}


#Preview {
    MaskBootCamp()
}
