//
//  AudioToTextView.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 13.11.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import AVKit
import SwiftUI

struct AudioToTextView: View {
    @ObservedObject var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared
    @ObservedObject var audioService = AudioService.shared
    @ObservedObject var subtitleService = SubtitleService.shared

    @State var height: CGFloat = 300
    @State var selectedText: String = ""
    @AppStorage("subtitles_currentLine") var currentLine: Int = 1
    @State var isPlaying = false

    var subtitlesUrl: URL? = nil

    var body: some View {
        VStack {
            TextField("Enter audio or video url", text: $audioService.url)
                .onSubmit {
                    audioService.restart()
                }

            VideoPlayer(player: audioService.player)
                .onReceive(NotificationCenter.default.publisher(for: .AVFragmentedMovieTrackSegmentsDidChange)) { _ in
                    audioService.player.seek(to: CMTime.zero)
                    audioService.player.play()
                }
                .frame(maxHeight: height)

            actionBarView

            subtitleListView

            recognizedTextView

            Spacer()
        }
        .frame(width: viewsStore.viewWidth[.audioToText] ?? ViewsStore.defaultWidth)
        .onAppear {
            audioService.restart()
        }
        .onDisappear {
            audioService.pause()
        }
        .onChange(of: selectedText) { text in
            if text.isEmpty == false {
                store.translateAction.addAll(text: text)
            }
        }
        .onReceive(audioService.ratePublisher) { rate in
            isPlaying = rate != 0
        }
    }
}

private extension AudioToTextView {
    var actionBarView: some View {
        HStack {
            Button {
                height = height == 50 ? 300 : 50
            } label: {
                Image(systemName: height == 50 ? "plus.magnifyingglass" : "minus.magnifyingglass")
            }

            Toggle("Recognize", isOn: $audioService.isRecognized)
                .toggleStyle(.switch)

            Button {
                subtitleService.selectedLines.removeAll()
            } label: {
                Image(systemName: "checkmark.circle")
            }

            Divider()

            Button {
                audioService.seek(seconds: -1)
            } label: {
                Image(systemName: "arrow.left")
            }

            Button {
                if audioService.player.isPlaying {
                    audioService.player.pause()
                } else {
                    audioService.player.play()
                }
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }

            Button {
                audioService.seek(seconds: 1)
            } label: {
                Image(systemName: "arrow.right")
            }

            Button(
                action: {
                    OpenPanel.showChooseFileDialog(
                        title: "Open SRT file",
                        allowedFileTypes: [.init(filenameExtension: "srt")!]
                    ) { url in
                        if let url,
                           let text = try? String(contentsOfFile: url.path, encoding: .utf8)
                        {
                            let subtitles = subtitleService.parseSRT(srt: text)

                            subtitleService.subtitles = subtitles
                        }
                    }
                },
                label: { Text("📂 SRF") }
            )
            .onHover { _ in
                print("Generate .srt by https://github.com/openai/whisper.git")
            }
        }
        .frame(height: 20)
    }

    var subtitleListView: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVStack(alignment: .leading) {
                    ForEach(subtitleService.subtitles, id: \.id) { line in
                        HStack {
                            Button {
                                let time = CMTime(seconds: line.start, preferredTimescale: 1)

                                if isPlaying {
                                    audioService.player.pause()
                                }else {
                                    audioService.player.seek(to: time)
                                    audioService.player.play()
                                }
                            } label: {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            }
                            .frame(width: 30, height: 10)

                            Text(line.text)
                                .onTapGesture {
                                    if subtitleService.selectedLines[line.id]?.isEmpty == false {
                                        subtitleService.selectedLines[line.id] = ""
                                    } else {
                                        subtitleService.selectedLines[line.id] = line.text
                                    }
                                }
                                .id(line.id)
                                .bold(subtitleService.selectedLines[line.id]?.isEmpty == false)
                                .underline(currentLine == line.id)
                                .simultaneousGesture(TapGesture())
                        }
                    }
                }
//                    .textSelection(.enabled)
                .onReceive(subtitleService.timerPublisher) { _ in
                    let player = audioService.player
                    if player.timeControlStatus == .playing {
                        let line = subtitleService.subtitles.last { item in
                            player.currentTime().seconds + 1 >= item.start
                        }

                        currentLine = line?.id ?? 1
                    }
                }
                .onReceive(subtitleService.subtitleServicePublisher) { selectedLines in
                    let text = selectedLines
                        .filter { _, value in
                            value.isEmpty == false
                        }
                        .sorted(by: {
                            $0.key < $1.key
                        })
                        .map(\.value)
                        .reduce(into: "") { partialResult, text in
                            partialResult += text
                        }

                    store.translateAction.addAll(text: text)
                }
                .onChange(of: currentLine) { line in
                    proxy.scrollTo(line + 5)
                }
            }
        }
    }

    @ViewBuilder
    var recognizedTextView: some View {
        #if os(macOS)
            TextField("", text: $audioService.text, axis: .vertical)
                .lineLimit(7)
                .frame(maxHeight: 100)
                .textFieldStyle(.roundedBorder)
        #endif

        #if os(iOS)
            TextEditor(text: $audioService.text)
                .textFieldStyle(.roundedBorder)
        #endif
    }
}

struct AudioToTextView_Previews: PreviewProvider {
    static var previews: some View {
        Text("test").foregroundColor(.blue)
    }
}
