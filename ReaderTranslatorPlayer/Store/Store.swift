//
//  Store.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
    static var shared = Store()

    @Published var hideNavBar = true

    var lastWebPage = ""

    @Published(key: "bookmarks") var bookmarks: BookmarksStore.Bookmarks = []

    @Published var longmanSentences: LongmanSentences = [LongmanSentence.empty]
    @Published var longmanSelectedBookmark = "" {
        willSet {
            longmanSentences = []
            LongmanStore.shared.fetchInfo(text: newValue)
        }
    }
    @Published var longmanAudioRate: Float = 1
}
