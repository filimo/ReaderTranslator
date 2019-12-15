//
//  PlayerContolsView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

private var timer: Timer?

struct PlayerControlsView: View {
    @ObservedObject var store = Store.shared

    @State var currentStatus = "0.0/0.0"
    @State var showSafari = false
    @State var showHosts = false

    private var playPauseButton: some View {
        Button(
            action: { self.store.isPlaying.toggle() },
            label: { Text(store.isPlaying ? "Pause" : "Play") }
        )
        .buttonStyle(RoundButtonStyle())
    }

    var body: some View {
        VStack(spacing: 10) {
            statusView.frame(width: 100)
            AudioRateView()
            RewindButtonsView()
            HStack(spacing: 40) {
                Button(action: {
                    self.showHosts = true
                }, label: { Image(systemName: "wifi") })
                    .padding(.leading)
                    .buttonStyle(RoundButtonStyle())
                Spacer()
                playPauseButton
                Button(action: { self.showSafari = true }, label: { Text("Safari") })
                    .buttonStyle(RoundButtonStyle())
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: .constant(URL(string: "https://www.ldoceonline.com")))
        }
        .sheet(isPresented: $showHosts) { HostsView() }
    }

    private var statusView: some View {
        let status = Text("\(currentStatus)")

        return Group {
            if store.isPlaying {
                status.onAppear { self.startTimer() }
            } else {
                status.onAppear { timer?.invalidate() }
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let player = FileListView.player else { return }
            self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
        }
    }
}

struct PlayerContolsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView()
    }
}
