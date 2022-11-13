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

    @State var height: CGFloat = 300
    @State var selectedText: String = ""

    var body: some View {
        VStack {
            TextField("Enter audio or video url", text: $audioService.url)
                .onSubmit {
                    audioService.restart()
                }

            VideoPlayer(player: audioService.player)
                .frame(maxHeight: height)

            HStack {
                Button {
                    height = height == 50 ? 300 : 50
                } label: {
                    Image(systemName: height == 50 ? "plus.magnifyingglass" : "minus.magnifyingglass")
                }

                Toggle("Recognize", isOn: $audioService.isRecognized)
                    .toggleStyle(.switch)

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
                    Image(systemName: audioService.player.isPlaying ? "pause.fill" : "play.fill")
                }

                Button {
                    audioService.seek(seconds: 1)
                } label: {
                    Image(systemName: "arrow.right")
                }
            }
            .frame(height: 20)

            NSTextViewRepresentable(text: $audioService.text, selectedText: $selectedText)
                .font(.title2)
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
    }
}

struct AudioToTextView_Previews: PreviewProvider {
    static var previews: some View {
        AudioToTextView()
    }
}
