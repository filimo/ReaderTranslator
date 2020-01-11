//
//  AudioPlayerView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 28/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Pdf_Toolbar: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var pdfStore = PdfStore.shared

    @State var player = AudioPlayer()
    @State var currentStatus = ""
    @State var isPlaying = false

    var body: some View {
        VStack {
            ReaderView_Pdf_Toolbar_PlayButtons(
                audioPlayer: $player,
                currentStatus: $currentStatus,
                isPlaying: $isPlaying
            )
            HStack {
                statusView
                audioRateButtonsView
            }
            HStack {
                openPdfButton
                openAudioButton
                pagesView
                zoomView
            }
        }
    }

    private var statusView: some View {
        Text(currentStatus).frame(width: 100)
    }

    private var openPdfButton: some View {
        Button(
            action: {
                OpenPanel.showChooseFileDialog(title: "Open PDF file", allowedFileTypes: ["pdf"]) { url in
                    guard let url = url?.absoluteString else { return }

                    self.pdfStore.lastPdfPage = "1"
                    self.pdfStore.lastPdf = url
                }
            },
            label: { Text("📂 PDF") }
        )
    }

    private var openAudioButton: some View {
        Button(action: {
            OpenPanel.showChooseFileDialog(title: "Open audio file", allowedFileTypes: ["mp3", "mov"]) { url in
                guard let url = url else { return }
                self.pdfStore.pdfAudio = url
                self.player.openAudio(url: url)
                self.player.rate = 1
                self.currentStatus = self.player.status
            }
        }, label: { Text("📂 audio") })
    }

    private var audioRateButtonsView: some View {
        HStack(spacing: 2) {
            Button(action: { self.player.rate = 0.2 }, label: { Text(".2") })
            Button(action: { self.player.rate = 0.5 }, label: { Text(".5") })
            Button(action: { self.player.rate -= 0.1 }, label: { Text("-") })
            Text(self.player.rateString)
            Button(action: { self.player.rate += 0.1 }, label: { Text("+") })
            Button(action: { self.player.rate = 1 }, label: { Text("1") })
        }
    }

    private var pagesView: some View {
        HStack {
            Text("Page:")
            #if os(macOS)
                TextField("   ", text: self.$pdfStore.currentPdfPage)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            #else
                TextField("   ", text: self.$store.currentPdfPage)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            #endif
            Text(" / \(self.pdfStore.pdfPageCount)")
        }
    }

    private var zoomView: some View {
        HStack {
            Text(" Zoom: ")
            TextField("   ", text: self.$pdfStore.pdfZoom)
                .fixedSize()
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct ReaderView_Pdf_Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Pdf_Toolbar()
    }
}
