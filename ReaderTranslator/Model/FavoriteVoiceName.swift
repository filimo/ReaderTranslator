//
//  FavoriteVoiceName.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/27/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct FavoriteVoiceName: Identifiable, Codable {
    var id = UUID()
    var language: String
    var voice: String
}

extension FavoriteVoiceName {
    static var isFavorite: Bool {
        Store.shared.favoriteVoiceNames.first { $0.voice == Store.shared.voiceName } != nil
    }

    static func addCurrentVoice() {
        let store = Store.shared

        FavoriteVoiceName.removeCurrentVoice()
        store.favoriteVoiceNames.append(.init(language: store.voiceLanguage, voice: store.voiceName))
    }

    static func removeCurrentVoice() {
        let store = Store.shared

        if let index = store.favoriteVoiceNames.firstIndex(where: { $0.voice == store.voiceName }) {
            store.favoriteVoiceNames.remove(at: index)
        }
    }
}
