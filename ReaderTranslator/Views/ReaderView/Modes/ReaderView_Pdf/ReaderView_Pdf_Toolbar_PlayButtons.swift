//
//  ReaderView_Pdf_Toolbar_PlayButtons.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

private var timer: Timer?

struct ReaderView_Pdf_Toolbar_PlayButtons: View {
    @Binding var audioPlayer: AudioPlayer
    @Binding var currentStatus: String
    @Binding var isPlaying: Bool {
        willSet {
            if newValue {
                startTimer()
            } else {
                timer?.invalidate()
            }
        }
    }

    @ObservedObject var store = Store.shared

    var body: some View {
        HStack(spacing: 2) {
            Button(action: { self.audioPlayer.player?.currentTime = 0 }, label: { Text("|<") })
            rewindButton(label: "-50", step: -50)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)

            playButtonView

            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+50", step: 50)
        }
        .onAppear {
            if let url = self.store.pdfAudio { self.audioPlayer.openAudio(url: url) }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var playButtonView: some View {
        Button(action: {
            guard let player = self.audioPlayer.player else { return }
            if self.isPlaying {
                player.pause()
            } else {
                // hack: currentTime jump forward for some time after an audio is continue to play
                let currentTime = player.currentTime
                player.play()
                player.currentTime = currentTime
            }
            self.isPlaying = player.isPlaying
        }, label: { Text(isPlaying ? "Pause" : "Play").frame(width: 40) })
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: {
            self.audioPlayer.player?.currentTime += step
            self.currentStatus = self.audioPlayer.status

        }, label: { Text(label) })
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let player = self.audioPlayer.player else { return }
            self.currentStatus = self.audioPlayer.status
            player.volume = self.store.audio.volume
            if self.isPlaying != player.isPlaying { self.isPlaying = player.isPlaying }
        }
    }
}
