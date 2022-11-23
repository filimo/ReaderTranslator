//
//  StatusBarView_Voice_Favorite.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SettingsView_Voice_Favorite: View {
    @ObservedObject var store = AudioStore.shared

    var body: some View {
        Group {
            favotiteButton()
            MenuButton(label: Image.sfSymbol("list.dash")) {
                ForEach(store.favoriteVoiceNames, id: \.id) { item in
                    Button(
                        action: {
                            self.store.language = item.language
                            self.store.voiceName = item.voice
                            SpeechSynthesizer.speak(isVoiceEnabled: true)
                        },
                        label: {
                            Text("\(item.language) \(item.voice)")
                        }
                    )
                }
            }
            .menuButtonStyle(BorderlessButtonMenuButtonStyle())
            .fixedSize()
        }
    }

    private func favotiteButton() -> some View {
        let action = store.isFavorite ?
            { store.removeCurrentVoice() } :
            { store.addCurrentVoice() }
        let label = store.isFavorite ?
            { Image.sfSymbol("star.fill") } :
            { Image.sfSymbol("star") }

        return Button(action: action, label: label)
    }
}

struct SettingsView_Voice_Favorite_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView_Voice_Favorite()
    }
}
