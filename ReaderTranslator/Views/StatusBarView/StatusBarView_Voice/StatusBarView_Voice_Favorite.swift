//
//  StatusBarView_Voice_Favorite.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Voice_Favorite: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            button()
            .contextMenu {
                ForEach(store.favoriteVoiceNames, id:\.id) { item in
                    Button(action: {
                        self.store.voiceLanguage = item.language
                        self.store.voiceName = item.voice
                        SpeechSynthesizer.speak(isVoiceEnabled: true)
                    }) {
                        Text("\(item.language) \(item.voice)")
                    }
                }
            }
        }
    }
    
    private func button() -> some View {
        if FavoriteVoiceName.isFavorite {
            return Button(action: {
                FavoriteVoiceName.removeCurrentVoice()
            }) {
                Image(systemName: "star.fill")
            }
        }else{
            return Button(action: {
                FavoriteVoiceName.addCurrentVoice()
            }) {
                Image(systemName: "star")
            }
        }
    }
}

struct StatusBarView_Voice_Favorite_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Voice_Favorite()
    }
}
