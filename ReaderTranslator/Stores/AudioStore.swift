//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import AVFoundation
import Foundation

final class AudioStore: NSObject, ObservableObject {
    private override init() {
        super.init()
    }
    
    static var shared = AudioStore()

    private var audioUrls = Stack<URL>()
    private var player: AVAudioNetPlayer?

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

extension AudioStore {
    func addAudio(url: URL) {
        audioUrls.push(url)
    }

    func play() {
        guard let url = audioUrls.pop() else { return }

        if AudioStore.shared.isSpeakWords {
            player = AVAudioNetPlayer()
            player?.delegate = self
            player?.play(url: url)
        }
    }
    
    func removeAllSounds() {
        audioUrls.removeAll()
    }
}

extension AudioStore: AVAudioNetPlayerDelegate {
    func audioPlayerLoadDidFinishDidOccur() {}

    func audioPlayerCreateSuccessOccur(player: AVAudioPlayer) {
        player.enableRate = true
        player.rate = LongmanStore.shared.audioRate
        player.volume = AudioStore.shared.wordsVolume
        player.play()
    }

    func audioPlayerLoadErrorDidOccur() { play() }
    func audioPlayerCreateErrorDidOccur() { play() }

    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) { play() }
    func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) { play() }
}
