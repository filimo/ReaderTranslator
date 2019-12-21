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
        AudioStore.shared.favoriteVoiceNames.first { $0.voice == AudioStore.shared.voiceName } != nil
    }

    static func addCurrentVoice() {
        let store = AudioStore.shared

        FavoriteVoiceName.removeCurrentVoice()
        store.favoriteVoiceNames.append(.init(language: store.language, voice: store.voiceName))
    }

    static func removeCurrentVoice() {
        let store = AudioStore.shared

        if let index = store.favoriteVoiceNames.firstIndex(where: { $0.voice == store.voiceName }) {
            store.favoriteVoiceNames.remove(at: index)
        }
    }
}
