//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class AudioStore: ObservableObject {
    private init() {}
    static var shared = AudioStore()

    @Published(key: "favoriteVoiceNames") var favoriteVoiceNames: [FavoriteVoiceName] = []
    @Published(key: "voiceLanguage") var language = "Select language"
    @Published(key: "voiceName") var voiceName = "Select voice"
    @Published(key: "isSpeakSentences") var isSpeakSentences = true { didSet { SpeechSynthesizer.speak() } }
    @Published(key: "isSpeakWords") var isSpeakWords = true { didSet { SpeechSynthesizer.speak() } }
    @Published(key: "voiceRate") var rate: Float = 0.5
    @Published(key: "sentencesVolume") var sentencesVolume: Float = 1
    @Published(key: "wordsVolume") var wordsVolume: Float = 1
    @Published(key: "playbackRate") var playbackRate: Float = 1.0
}
