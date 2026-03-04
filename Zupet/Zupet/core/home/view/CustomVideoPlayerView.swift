//
//  EmptyCart.swift
//  Zupet
//
//  Created by Arpit Verma on 2/24/26.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewControllerRepresentable {
    let videoName: String
    var videoSpeed: Float = 0.25
    @Binding var isPlaying: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill

        let videoFileName = videoName.replacingOccurrences(of: ".mp4", with: "")
        var url: URL?

        if let dataAsset = NSDataAsset(name: videoFileName) {
            let tempDir = FileManager.default.temporaryDirectory
            let tempFile = tempDir.appendingPathComponent("\(videoFileName).mp4")
            do {
                try dataAsset.data.write(to: tempFile)
                url = tempFile
                context.coordinator.tempFileURL = tempFile
            } catch {
                print("Zupet: Failed to write video data: \(error)")
            }
        }

        if url == nil {
            if let path = Bundle.main.path(forResource: videoFileName, ofType: "mp4") {
                url = URL(fileURLWithPath: path)
            } else if let resourceURL = Bundle.main.url(forResource: videoFileName, withExtension: "mp4") {
                url = resourceURL
            }
        }

        guard let videoURL = url else {
            return controller
        }

        let player = AVPlayer(url: videoURL)
        player.actionAtItemEnd = .none
        player.rate = videoSpeed
        context.coordinator.player = player

        let observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            if context.coordinator.isPlaying {
                player.play()
            }
        }
        context.coordinator.endTimeObserver = observer
        controller.player = player
        player.pause()

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying != context.coordinator.isPlaying {
            context.coordinator.isPlaying = isPlaying
            if let player = context.coordinator.player {
                if isPlaying {
                    player.rate = videoSpeed
                    player.play()
                } else {
                    player.pause()
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var player: AVPlayer?
        var isPlaying: Bool = false
        var endTimeObserver: NSObjectProtocol?
        var tempFileURL: URL?

        deinit {
            if let observer = endTimeObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            if let tempURL = tempFileURL {
                try? FileManager.default.removeItem(at: tempURL)
            }
        }
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        coordinator.player?.pause()
        if let observer = coordinator.endTimeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let tempURL = coordinator.tempFileURL {
            try? FileManager.default.removeItem(at: tempURL)
        }
    }
}
