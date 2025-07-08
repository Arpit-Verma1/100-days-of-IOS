//
//  segmentedControl.swift
//  ios_26
//
//  Created by Arpit Verma on 7/7/25.
//

import SwiftUI

struct segmentedControl: View {
    
    
    @State private var tabs: [SegmentTab] = [
        .init(id: 0, title: "Time Laps"),
        .init(id: 1, title: "SLO-MO"),
        .init(id: 2, title: "Photo"),
        .init(id: 3, title: "Video"),
        .init(id: 4, title: "Potrait"),
        .init(id: 5, title: "PANO")
    ]
    
    @State private var isSegementGestureActive : Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.black)
                .backgroundExtensionEffect()
            
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.white)
                            .frame(width: 80 , height: 80)
                        
                        Spacer(minLength: 0)
                        
                        HStack (spacing: 20) {
                            Button {
                                    
                            } label: {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                    
                                
                            
                            }
                            .offset(x : isSegementGestureActive ? -100 : 0 )

                            customSegmentControl(initialIndex: 0,horizontalPadding: 70, tabs: $tabs) { index in
                                
                            } gestureStatus: { isActive in
                                isSegementGestureActive = isActive
                            }
                            Button {
                                    
                            } label: {
                                Circle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image(systemName: "arrow.triangelhead.2.counterclockwise.rotate.90")
                                            .foregroundStyle(.white)
                                    }
                                
                            
                            }
                            .offset(x : isSegementGestureActive ? 100 : 0 )
                        }.padding(.horizontal, 30)
                    }.padding(.horizontal, 20)
                }
        }
    }
}

#Preview {
    segmentedControl()
}
