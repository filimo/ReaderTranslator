//
//  StatusBarView_Voice_Toggle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/3/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Toggle: View {
    @ObservedObject var audio = AudioStore.shared
    
    private var isSpeakSentencesSign: Character {
        audio.isSpeakSentences ? "👍" : "👎"
    }

    private var isSpeakWordsSign: Character {
        audio.isSpeakWords ? "👍" : "👎"
    }

    var body: some View {
        Group {
            MenuButton("Speak: \(isSpeakSentencesSign)\(isSpeakWordsSign)") {
                VStack(spacing: 0) {
                    Text("Speak sentences")
                    HStack {
                        Image.sfSymbol(audio.isSpeakSentences ? "speaker.3.fill" : "speaker")
                            .onTapGesture { self.audio.isSpeakSentences.toggle() }
                        Slider(
                            value: $audio.sentencesVolume,
                            in: 0.1 ... 1.0,
                            onEditingChanged: { _ in SpeechSynthesizer.speak() }
                        ).frame(width: 100)
                    }
                    Divider()
                    Text("Speak words")
                    HStack {
                        Image.sfSymbol(audio.isSpeakWords ? "speaker.3.fill" : "speaker")
                            .onTapGesture { self.audio.isSpeakWords.toggle() }
                        Slider(
                            value: $audio.wordsVolume,
                            in: 0.1 ... 1.0,
                            onEditingChanged: { _ in SpeechSynthesizer.speak() }
                        ).frame(width: 100)
                    }
                }
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .fixedSize()
        }
    }
}
