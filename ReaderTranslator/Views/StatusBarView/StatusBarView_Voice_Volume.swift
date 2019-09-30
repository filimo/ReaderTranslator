//
//  StatusBarView_Voice_Volume.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Volume: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            Toggle(isOn: $store.isVoiceEnabled) {
                Text("On:")
                Button(action: {
                    SpeechSynthesizer.speech()
                }) {
                    store.isVoiceEnabled ? Image(systemName: "volume.3.fill") : Image(systemName: "speaker")
                }
            }.fixedSize()
            Text("Rate:")
            #if os(macOS)
            TextField("   ", text: self.$store.voiceRate)
                .fixedSize()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            #else
            TextField("   ", text: self.$store.voiceRate)
                .fixedSize()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
            #endif
        }
    }
}

struct StatusBarView_Voice_Volume_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice_Volume()
    }
}
