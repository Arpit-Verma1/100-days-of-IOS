//
//  LoadingView.swift
//  Zupet
//
//  Created by Arpit Verma on 2/27/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var isPlaying: Bool = false
    
    var body: some View {
        VStack {
            CustomVideoPlayerView(videoName: "loading.mp4", isPlaying: $isPlaying, )
                .frame(width: 200,height: 200)

            
        }
        .onAppear{
            isPlaying = true
        }
    }
    
}

#Preview {
    LoadingView()
}
