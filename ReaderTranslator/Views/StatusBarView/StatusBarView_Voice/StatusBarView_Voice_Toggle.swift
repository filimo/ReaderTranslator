//
//  StatusBarView_Voice_Toggle.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/3/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Toggle: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            Toggle(isOn: $store.isVoiceEnabled) {
                Text("On:")
            }.fixedSize()
            Image(systemName: store.isVoiceEnabled ? "volume.3.fill" : "speaker")
                .onTapGesture {
                    SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true)
                }
        }
    }
}
