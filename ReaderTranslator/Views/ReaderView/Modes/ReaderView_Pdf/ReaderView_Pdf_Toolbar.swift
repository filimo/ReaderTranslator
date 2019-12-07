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

struct ReaderView_Pdf_Toolbar: View {
    @ObservedObject var store = Store.shared

    @State var currentStatus = ""
    @State var isPlaying = false
    @State var audioRate: Float = 1 {
        didSet {
            player?.rate = audioRate
        }
    }

    private var openPdfButton: some View {
        Button(
            action: {
                OpenPanel.showChooseFileDialog(title: "Open PDF file", allowedFileTypes: ["pdf"]) { url in
                    guard let url = url?.absoluteString else { return }

                    self.store.lastPdfPage = "1"
                    self.store.lastPdf = url
                }
            },
            label: { Text("Open PDF") })
    }

    private var openAudioButton: some View {
        Button(action: {
            OpenPanel.showChooseFileDialog(title: "Open audio file", allowedFileTypes: ["mp3", "mov"]) { url in
                guard let url = url else { return }
                self.store.pdfAudio = url
                self.openAudio(url: url)
                self.audioRate = 1
            }
        }, label: { Text("Open audio") })
    }

    private var rewindButtonsView: some View {
        HStack(spacing: 2) {
            Button(action: { player?.currentTime = 0 }, label: { Text("|<") })
            rewindButton(label: "-50", step: -50)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)

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
            }, label: { Text(isPlaying ? "Pause" : "Play").frame(width: 40) })

            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+50", step: 50)
        }
    }

    private var audioRateButtonsView: some View {
        HStack(spacing: 2) {
            Divider()
            Button(action: { self.audioRate = 0.2 }, label: { Text(".2") })
            Button(action: { self.audioRate = 0.5 }, label: { Text(".5") })
            Button(action: { self.audioRate -= 0.1 }, label: { Text("-") })
            Text(String(format: "%.1f", arguments: [audioRate]))
            Button(action: { self.audioRate += 0.1 }, label: { Text("+") })
            Button(action: { self.audioRate = 1 }, label: { Text("1") })
        }
    }

    var body: some View {
        VStack {
            HStack {
                openPdfButton
                openAudioButton

                Text("\(currentStatus)").frame(width: 100)
            }
            HStack {
                rewindButtonsView
                audioRateButtonsView
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

struct ReaderView_Pdf_Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Pdf_Toolbar()
    }
}
