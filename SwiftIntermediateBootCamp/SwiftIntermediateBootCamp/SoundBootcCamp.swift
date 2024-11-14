//
//  SoundBootcCamp.swift
//  SwiftInterMediateBootCamp
//
//  Created by Arpit Verma on 15/11/24.
//

import SwiftUI
import AVKit

class SoundManager {
    static let instace = SoundManager()
    var player: AVAudioPlayer?
    func playsound() {
        guard let url = Bundle.main.url(forResource: "tada", withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print(error)
        }
    }
}

struct SoundBootcCamp: View {
    var body: some View {
        Button("play sound") {
            SoundManager.instace.playsound()
        }
    }
}

#Preview {
    SoundBootcCamp()
}
