//
//  PlayerContolsView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct PlayerControlsView: View {
    @State var currentStatus = "0.0/0.0"
    @State var isPlaying = false
    @State var showSafari = false

    private var playPauseButton: some View {
        Button(
            action: {
                guard let player = player else { return }
                if self.isPlaying {
                    player.pause()
                } else {
                    //hack: currentTime jump forward for some time after an audio is continue to play
                    let currentTime = player.currentTime
                    player.play()
                    player.currentTime = currentTime
                }
            },
            label: { Text(isPlaying ? "Pause" : "Play") })
            .buttonStyle(RoundButtonStyle())
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("\(currentStatus)").frame(width: 100)
            AudioRateView()
            RewindButtonsView()
            HStack(spacing: 40) {
                Spacer()
                playPauseButton
                Button(
                    action: { self.showSafari = true },
                    label: { Text("Safari") })
                    .buttonStyle(RoundButtonStyle())
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: .constant(URL(string: "https://www.ldoceonline.com")))
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                guard let player = player else { return }
                self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
                self.isPlaying = player.isPlaying
            }
        }
    }
}

struct PlayerContolsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView()
    }
}
