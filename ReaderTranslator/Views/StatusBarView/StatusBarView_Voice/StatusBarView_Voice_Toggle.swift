//
//  StatusBarView_Voice_Toggle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/3/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Toggle: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        Group {
            Toggle(isOn: $store.isVoiceEnabled) {
                Text("On:")
            }.fixedSize()
            Image.sfSymbol(store.isVoiceEnabled ? "speaker.3.fill" : "speaker")
                .onTapGesture {
                    SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true)
                }
                .contextMenu {
                    Slider(value: $store.voiceVolume, in: 0.1 ... 1.0).frame(width: 100, height: 50)
                }
        }
    }
}
