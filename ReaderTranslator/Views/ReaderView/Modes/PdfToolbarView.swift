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
                    do {
                        player = try AVAudioPlayer(contentsOf: url)
                        player?.enableRate = true
                    } catch {
                        print(error)
                    }
                }
            }, label: { Text("Open audio") })

            Group {
                Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
                Button(action: { player?.currentTime -= 100 }, label: { Text("-100") })
                Button(action: { player?.currentTime -= 10 }, label: { Text("-10") })
                Button(action: { player?.currentTime -= 5 }, label: { Text("-5") })
                Button(action: { player?.currentTime -= 1 }, label: { Text("-1") })
            }

            Button(action: {
                if self.isPlaying { player?.pause() } else { player?.play() }
            }, label: { Text(isPlaying ? "Pause" : "Play") })

            Group {
                Button(action: { player?.currentTime += 1 }, label: { Text("+1") })
                Button(action: { player?.currentTime += 5 }, label: { Text("+5") })
                Button(action: { player?.currentTime += 10 }, label: { Text("+10") })
                Button(action: { player?.currentTime += 100 }, label: { Text("+100") })
            }

            Group {
                Divider()
                Button(action: { self.audioRate -= 0.1 }, label: { Text("-") })
                Text(String(format: "%.1f", arguments: [audioRate]))
                Button(action: { self.audioRate += 0.1 }, label: { Text("+") })
            }

            Group {
                Divider()
                Text("\(currentStatus)")
            }
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

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PdfToolbarView()
    }
}
