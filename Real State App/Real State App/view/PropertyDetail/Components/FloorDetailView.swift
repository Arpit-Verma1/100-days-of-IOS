//
//  FloorDetailView.swift
//  Real State App
//
//  Created by Arpit Verma on 1/12/26.
//

import SwiftUI

// Floor Detail View with video background
struct FloorDetailView: View {
    let videoName: String
    let floorNumber: Int
    var onClose: () -> Void
    @State private var isVideoPlaying = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                CustomVideoPlayerView(videoName: videoName, videoSpeed: 0.1, isPlaying: $isVideoPlaying)
                    .frame(width: geometry.size.width, height: geometry.size.height + 100)
                    .clipped()
                    .ignoresSafeArea(.all)
                
                
                HStack {
                    
                    Spacer()
                    Button(action: {
                        isVideoPlaying = false
                        onClose()
                    }) {
                        Image(systemName: "xmark" )
                            .foregroundColor( .white)
                            .font(.system(size: 12, weight: .semibold))
                            .frame(width: 54, height: 54)
                            .background(
                                Circle()
                                    .fill(.blue.opacity(0.1))
                            )
                    }
                    .glassEffect(.clear)
                    .padding(16)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
        }
        .onAppear {
            isVideoPlaying = true
        }
    }
}
#Preview {
    FloorDetailView(videoName: "interior.mp4", floorNumber: 1, onClose: {})
}
