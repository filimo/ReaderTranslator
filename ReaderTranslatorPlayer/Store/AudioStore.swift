//
//  AudioStore.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class AudioStore: ObservableObject {
    private init() {}
    static var shared = AudioStore()

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
    @Published(key: "isVoiceEnabled") var isEnabled = true
    @Published(key: "voiceVolume") var volume: Float = 1
    @Published(key: "audioRate") var rate: Float = 1
}
