//
//  AudioPlayerView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 28/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import AVFoundation

private var player: AVAudioPlayer?

struct PdfToolbarView: View {
    @ObservedObject var store = Store.shared

    @State var currentStatus = ""
    @State var isPlaying = false
    @State var audioRate: Float = 1 {
        didSet {
            player?.rate = audioRate
        }
    }

    var body: some View {
        HStack {
            Button(
                action: {
                    OpenPanel.showChooseFileDialog(title: "Open PDF file", allowedFileTypes: ["pdf"]) { url in
                        guard let url = url?.absoluteString else { return }

                        self.store.lastPdfPage = "1"
                        self.store.lastPdf = url
                    }
                },
                label: { Text("Open PDF") })

            Button(action: {
                OpenPanel.showChooseFileDialog(title: "Open audio file", allowedFileTypes: ["mp3", "mov"]) { url in
                    guard let url = url else { return }
                    self.store.pdfAudio = url
                    self.openAudio(url: url)
                    self.audioRate = 1
                }
            }, label: { Text("Open audio") })

            Text("\(currentStatus)").frame(width: 100)

            Group {
                Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
                rewindButton(label: "-100", step: -100)
                rewindButton(label: "-5", step: -5)
                rewindButton(label: "-1", step: -1)
            }

            Button(action: {
                guard let player = player else { return }
                if self.isPlaying {
                    player.pause()
                } else {
                    //hack: currentTime jump forward for some time after an audio is continue to play
                    let currentTime = player.currentTime
                    player.play()
                    player.currentTime = currentTime
                }
            }, label: { Text(isPlaying ? "Pause" : "Play ") })

            Group {
                rewindButton(label: "+1", step: 1)
                rewindButton(label: "+5", step: 5)
                rewindButton(label: "+100", step: 100)
            }

            Group {
                Divider()
                Button(action: { self.audioRate -= 0.1 }, label: { Text("-") })
                Text(String(format: "%.1f", arguments: [audioRate]))
                Button(action: { self.audioRate += 0.1 }, label: { Text("+") })
            }
        }
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                guard let player = player else { return }
                self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
                self.isPlaying = player.isPlaying
            }
            if let url = self.store.pdfAudio { self.openAudio(url: url) }
        }
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: { player?.currentTime += step }, label: { Text(label) })
    }

    private func openAudio(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        player?.enableRate = true
    }
}

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PdfToolbarView()
    }
}
