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

    var body: some View {
        Group {
            Toggle(isOn: $audio.isEnabled) {
                Text("On:")
            }.fixedSize()
            Image.sfSymbol(audio.isEnabled ? "speaker.3.fill" : "speaker")
                .onTapGesture {
                    SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true)
                }
                .contextMenu {
                    Slider(value: $audio.volume, in: 0.1 ... 1.0).frame(width: 100, height: 50)
                }
        }
    }
}
