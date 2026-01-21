//
//  VideoPlayerView.swift
//  retroCar
//
//  Created by Arpit Verma on 1/18/26.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var observer: NSObjectProtocol?
    @Binding var showVideo: Bool
    @Binding var isAnimating: Bool
    @Binding var circleScale: CGFloat
    @Binding var textOpacity: Double
    
    var body: some View {
        ZStack {
            // Transparent background - no black background
            Color.clear
                .ignoresSafeArea()
            
            if let player = player {
                CustomVideoPlayer(player: player)
                    .frame(width: 200, height: 200)
                    .onAppear {
                        setupVideoObserver()
                        player.play()
                    }
            }
        }
        .onAppear {
            loadVideo()
        }
        .onTapGesture {
            dismissVideo()
        }
        .onDisappear {
            removeVideoObserver()
        }
    }
    
    private func loadVideo() {
        // Load video from asset catalog dataset using NSDataAsset
        if let dataAsset = NSDataAsset(name: "meter") {
            // Create a temporary file URL to play the video
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("meter.mp4")
            
            do {
                try dataAsset.data.write(to: tempURL)
                let url = tempURL
                playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
            } catch {
                print("Error writing video data: \(error)")
            }
        } else {
            // Fallback: try to load from bundle
            if let url = Bundle.main.url(forResource: "meter", withExtension: "mp4") {
                playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
            }
        }
    }
    
    private func setupVideoObserver() {
        guard let playerItem = playerItem else { return }
        
        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            // Wait 1 second after video ends, then animate back
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                animateBackToOriginal()
            }
        }
    }
    
    private func removeVideoObserver() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
            self.observer = nil
        }
    }
    
    private func animateBackToOriginal() {
        // Hide video first
       
        isAnimating = false
        showVideo = false
        player?.pause()
        player?.seek(to: .zero) // Reset video to beginning
        // Animate circle reducing and text appearing
        
        
        // After animation, restore the main content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.8)) {
                circleScale = 1.0
                textOpacity = 1.0
            }
        }
    }
    
    private func dismissVideo() {
        player?.pause()
        animateBackToOriginal()
    }
}

struct CustomVideoPlayer: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        
        DispatchQueue.main.async {
            playerLayer.frame = view.bounds
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
        }
    }
}
