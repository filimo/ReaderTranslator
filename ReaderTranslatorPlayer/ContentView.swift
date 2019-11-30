//
//  ContentView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 29/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import AVFoundation

private var player: AVAudioPlayer?

struct ContentView: View {
    @ObservedObject var store = Store.shared
    @State var currentStatus = ""
    @State var isPlaying = false
    @State var audioRate: Float = Store.shared.audioRate {
        didSet {
            player?.rate = audioRate
            store.audioRate = audioRate
        }
    }
    @State var files: [URL] = []

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
            .buttonStyle(DefaultButtonStyle())
    }

    private var audioRateView: some View {
        HStack {
            Button(action: { self.audioRate -= 0.1 }, label: { Text("-") })
                .buttonStyle(DefaultButtonStyle())
            Text(String(format: "%.1f", arguments: [audioRate])).padding(5)
            Button(action: { self.audioRate += 0.1 }, label: { Text("+") })
                .buttonStyle(DefaultButtonStyle())
        }
    }

    private var rewindView: some View {
        HStack {
            Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
                .buttonStyle(DefaultButtonStyle())
            rewindButton(label: "-100", step: -100)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)
            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+100", step: 100)
        }
    }

    private var fileList: some View {
        List {
            ForEach(files, id: \.self) { url in
                Button(action: {
                    self.store.lastAudio = url
                    self.openAudio(url: url)
                    player?.play()
                }, label: {
                    Text("\(url.lastPathComponent)")
                    .foregroundColor(
                        self.store.lastAudio?.lastPathComponent == url.lastPathComponent ? Color.yellow: Color.primary)
                })
            }
            .onDelete { indexSet in
                guard let first = indexSet.first else { return }
                let file = self.files[first]
                do {
                    try FileManager.default.removeItem(at: file)
                    self.refresh()
                } catch {
                    print(error)
                }
            }
        }
    }

    init() {
        do {
            let sharedInstance = AVAudioSession.sharedInstance()

            try sharedInstance.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try sharedInstance.setActive(true)
        } catch {
            print(error)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("\(currentStatus)").frame(width: 100)
            audioRateView
            rewindView
            playPauseButton
            fileList
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                guard let player = player else { return }
                self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
                self.isPlaying = player.isPlaying
            }
            RunLoop.main.perform {
                self.refresh()
            }
            if let lastAudio = self.store.lastAudio { self.openAudio(url: lastAudio) }            
        }
    }

    private func refresh() {
       guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.files = []
            return
       }

       do {
           let inbox = documentsUrl.appendingPathComponent("/Inbox")
           let items = try FileManager.default.contentsOfDirectory(at: inbox, includingPropertiesForKeys: nil)

           self.files = items
       } catch {
           print(error)
           self.files = []
       }
    }

    private func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.rate = self.audioRate
        } catch {
            print(error)
        }
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: { player?.currentTime += step }, label: { Text(label) })
            .buttonStyle(DefaultButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
