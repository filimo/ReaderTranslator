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
    static func speak(
        text: String = Store.shared.selectedText,
        voiceName: String = Store.shared.voiceName,
        stopSpeaking: Bool = false,
        isVoiceEnabled: Bool = Store.shared.isVoiceEnabled) {
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)

        speechUtterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == voiceName })
        speechUtterance.rate = (Store.shared.voiceRate as NSString).floatValue
        if speechSynthesizer.isSpeaking {
            SpeechSynthesizer.stop()
            if stopSpeaking { return }
        }
        if isVoiceEnabled {
            speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(speechUtterance)
        }
    }
}
