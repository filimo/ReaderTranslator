//
//  StatusBarView_Voice_Select.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Select: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            Text(store.voiceLanguage)
                .contextMenu {
                    ForEach(SpeechSynthesizer.languages, id: \.self) { language in
                        Button(action: {
                            self.store.voiceLanguage = language
                            self.store.voiceName = "Select voice"
                        }) {
                            Text(language)
                        }
                    }
            }
            Text(store.voiceName)
                .contextMenu {
                    ForEach(SpeechSynthesizer.getVoices(language: store.voiceLanguage), id: \.id) { voice in
                        Button(action: {
                            self.store.voiceName = voice.name
                            SpeechSynthesizer.speak(isVoiceEnabled: true)
                        }) {
                            Text("\(voice.name) \(voice.premium ? "(premium)" : "")")
                        }
                    }
            }
        }
    }
}

struct StatusBarView_Voice_Select_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice_Select()
    }
}
