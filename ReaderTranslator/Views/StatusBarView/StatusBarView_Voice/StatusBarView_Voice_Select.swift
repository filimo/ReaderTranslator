//
//  StatusBarView_Voice_Select.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Select: View {
    @ObservedObject var store = AudioStore.shared

    var body: some View {
        Group {
            MenuButton(store.language) {
                ForEach(SpeechSynthesizer.languages, id: \.self) { language in
                    Button(
                        action: {
                            self.store.language = language
                            self.store.voiceName = "Select voice"
                        },
                        label: { Text(language) }
                    )
                }.fixedSize()
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .fixedSize()

            MenuButton(store.voiceName) {
                ForEach(SpeechSynthesizer.getVoices(language: store.language), id: \.id) { voice in
                    Button(
                        action: {
                            self.store.voiceName = voice.name
                            SpeechSynthesizer.speak(isVoiceEnabled: true)
                        },
                        label: {
                            Text("\(voice.name) \(voice.premium ? "(premium)" : "")")
                        }
                    )
                }
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .fixedSize()
        }
    }
}

struct StatusBarView_Voice_Select_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice_Select()
    }
}
