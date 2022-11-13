//
//  SpeechSynthesizer.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import Foundation
import Speech

private var cancellableSpeakers: AnyCancellable?

struct VoiceInfo {
    let id = UUID()
    let name: String
    let premium: Bool
    let language: String
    let voice: AVSpeechSynthesisVoice
}

extension Array where Element: Hashable {
    var unique: [Element] {
        Array(Set(self))
    }
}

class SpeechSynthesizer {
    private static var speechSynthesizer = AVSpeechSynthesizer()
    static var languages: [String] = {
        var items = AVSpeechSynthesisVoice.speechVoices().map { $0.language }.unique
        items.sort { left, right -> Bool in
            left < right
        }
        return items
    }()

    private init() {}

    static func getVoices(language: String) -> [VoiceInfo] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language == language }
            .map { voice in
                .init(
                    name: voice.name,
                    premium: voice.description.contains("premium"),
                    language: voice.language,
                    voice: voice
                )
            }
    }

    static func stop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    /*
     selecting text that calls speak()
     the sound button calls speak() with isVoiceEnabled = true, stopSpeaking = true
     select voice calls speak() with isVoiceEnabled = true, stopSpeaking = true
     the shortcut calls speak() with isVoiceEnabled = true
     isVoiceEnabled = true calls speak()
     isVoiceEnabled = false calls stop()
     */
    @MainActor static func speak(
        text: String? = nil,
        voiceName: String = AudioStore.shared.voiceName,
        stopSpeaking: Bool = false,
        isVoiceEnabled: Bool = AudioStore.shared.isSpeakSentences,
        enabledSpeakByEngine: Bool = true
    ) {
        let text = text ?? Store.shared.translateAction.getText()
        
        if speechSynthesizer.isSpeaking {
            SpeechSynthesizer.stop()
            if stopSpeaking { return }
        }

        AudioStore.shared.removeAllSounds()

        cancellableSpeakers = Publishers
            .CombineLatest3(
                CambridgeStore.shared.fetchInfo(text: text),
                CollinsStore.shared.fetchInfo(text: text),
                LongmanStore.shared.fetchInfo(text: text)
            )
            .sink { hasLongmanSound, hasCambridgeSound, hasCollinsSound in
                if hasCambridgeSound {
                    AudioStore.shared.play()
                } else if hasLongmanSound {
                    AudioStore.shared.play()
                } else if hasCollinsSound {
                    AudioStore.shared.play()
                } else {
                    if enabledSpeakByEngine {
                        speakByEngine(text: text, voiceName: voiceName, isVoiceEnabled: isVoiceEnabled)
                    }
                }
            }
    }

    private static func speakByEngine(text: String, voiceName: String, isVoiceEnabled: Bool) {
        let speechUtterance = AVSpeechUtterance(string: text)

        speechUtterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == voiceName })
        speechUtterance.volume = AudioStore.shared.sentencesVolume
        speechUtterance.rate = AudioStore.shared.rate
        if isVoiceEnabled {
            speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(speechUtterance)
        }
    }
}
