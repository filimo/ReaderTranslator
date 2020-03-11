//
//  StatusBarView_Voice_Toggle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/3/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView_Voice_Toggle: View {
    @ObservedObject var audio = AudioStore.shared

    var body: some View {
        VStack {
            HStack {
                Text("Speak sentences")
                Image.sfSymbol(audio.isSpeakSentences ? "speaker.3.fill" : "speaker")
                    .onTapGesture { self.audio.isSpeakSentences.toggle() }
                Slider(
                    value: $audio.sentencesVolume,
                    in: 0.1 ... 1.0,
                    onEditingChanged: { _ in SpeechSynthesizer.speak() }
                ).frame(width: 100)
            }
            HStack {
                Text("Speak words")
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
}
