//
//  Store.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

class Store: ObservableObject {
    static var shared = Store()

    @Published var hideNavBar = true

    var lastWebPage = ""

    @Published var isPlaying = false {
        willSet {
            guard let player = FileListView.player else { return }

            if newValue {
                let currentTime = player.currentTime
                player.play()
                player.currentTime = currentTime
            } else {
                player.pause()
            }
        }
    }

    @Published(wrappedValue: nil, key: "lastAudio") var lastAudio: URL?
    @Published(key: "voiceVolume") var voiceVolume: Float = 1
    @Published(key: "audioRate") var audioRate: Float = 1

    @Published(key: "bookmarks") var bookmarks: Bookmarks = []

    @Published var longmanSentences: LongmanSentences = [LongmanSentence.empty]
    @Published var longmanSelectedBookmark = "" {
        willSet {
            longmanSentences = []
            LongmanStore.share.fetchInfo(text: newValue)
        }
    }

    @Published var longmanAudioRate: Float = 1
}
