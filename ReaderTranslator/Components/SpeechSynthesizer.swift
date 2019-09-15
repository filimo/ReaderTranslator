//
//  SpeechSynthesizer.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Speech

class SpeechSynthesizer {
    static private var speechSynthesizer = AVSpeechSynthesizer()
    private init() { }
    
    static func speech(text: String) {
        for availableVoice in AVSpeechSynthesisVoice.speechVoices() {
            if availableVoice.language == "en-US" && availableVoice.debugDescription.contains("premium") {
                print(availableVoice.debugDescription)
            }
        }

        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice.speechVoices().first(where: { $0.name == "Tessa" })
        speechUtterance.rate = 0.4

        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.speak(speechUtterance)
    }
}
