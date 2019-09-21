//
//  SpeechSynthesizer.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Speech

struct VoiceInfo {
    let id = UUID()
    let name: String
    let premium: Bool
    let language: String
    let voice: AVSpeechSynthesisVoice
}

extension Array where Element : Hashable {
    var unique: [Element] {
        Array(Set(self))
    }
}

class SpeechSynthesizer {    
    static private var speechSynthesizer = AVSpeechSynthesizer()
    static var languages: [String] = {
        var items = AVSpeechSynthesisVoice.speechVoices().map { $0.language }.unique
        items.sort { left, right -> Bool in
            left < right
        }
        return items
    }()
    
    private init() { }

    static func getVoices(language: String) -> [VoiceInfo] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter({ $0.language == language })
            .map { voice in
                .init(name: voice.name, premium: voice.description.contains("premium"), language: voice.language, voice: voice)
            }
    }

    static func speech(text: String = Store.shared.selectedText, voiceName: String = Store.shared.voiceName) {
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == voiceName })
        speechUtterance.rate = Float(Store.shared.voiceRate) ?? 0.5

        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.speak(speechUtterance)
    }
}
