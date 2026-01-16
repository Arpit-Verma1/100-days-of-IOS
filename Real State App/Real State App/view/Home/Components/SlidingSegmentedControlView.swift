//
//  SlidingSegmentedControlView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/10/26.
//

import Foundation
import SwiftUI

struct SlidingSegmentedControlView: View {
    @Binding  var selected : String
    @Namespace private var animation
    @State var options : [String]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                ZStack {
                    if selected == option {
                        RoundedRectangle(cornerRadius: 30)
                            
                            .fill(Color.white)
                            .frame(width: 70, height: 40)
                        
                            .matchedGeometryEffect(id: "pill", in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 4, x:4, y: 4)
                    }

                    Text(option)
                        .font(.custom("HelveticaNowDisplay-Bold", size: 16))
                        .foregroundColor(selected == option ? .black : .gray)
                }
                
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selected = option
                    }
                }
            }
        }
        .padding(2)
        .frame(height: 50)
        .background(Color(hex : "#f3f5f7"))
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    SlidingSegmentedControlView(selected :.constant("Any")
                               , options:  ["Any", "1", "2", "3", "4+"])
}
