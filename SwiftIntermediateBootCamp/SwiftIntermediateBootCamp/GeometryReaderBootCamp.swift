//
//  GeometryReaderBootCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 13/11/24.
//

import SwiftUI

struct GeometryReaderBootCamp: View {
    func getPercentage(geo: GeometryProxy) -> Double {
        let maxDistance = UIScreen.main.bounds.width / 2
        let currentX = geo.frame(in: .global).midX
        return Double(1-(currentX)/Double(maxDistance))
    }
    var body: some View {
//        GeometryReader { geometry in
//            HStack(spacing: 0){
//                Rectangle().fill(Color.red)
//                    .frame(width: geometry.size.width*0.7)
//                Rectangle().fill(Color.blue)
//                
//            }
//            
//        }.ignoresSafeArea()
        ScrollView(.horizontal ,showsIndicators: false) {
            HStack {
                ForEach(0..<10) { index in
                    GeometryReader { geometry in
                        RoundedRectangle
                            .init(cornerRadius: 20)
                            .fill(Color.red)
        
                            .rotation3DEffect(Angle(degrees: getPercentage(geo: geometry)*40),
                                              axis: (x:CGFloat(0.0),y:CGFloat(1.0)  ,z:CGFloat(0.0))
                            
                            )
                    }.frame(width: 300,height: 250  )
                        .padding()
                    
                }
            }
        }
        
        
    }
}

#Preview {
    GeometryReaderBootCamp()
}
