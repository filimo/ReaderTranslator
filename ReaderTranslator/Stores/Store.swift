//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import SwiftUI

class Store: ObservableObject {
    static var shared = Store()

    var maxViewWidth: CGFloat = 400

    @Published(key: "canSafariSendSelectedText") var canSafariSendSelectedText: Bool = true

    @Published var translateAction = TranslateAction()

    @Published(key: "enabledViews") var enabledViews: Set<AvailableView> = [.reverso, .gTranslator]
    @Published(key: "viewWidth") var viewWidth: [AvailableView: CGFloat] = [:]
    @Published(key: "viewOrder") var viewOrder: [AvailableView: Int] = [:]

    @Published var currentPdfPage = "1"
    @Published var pageCount = 0
    @Published(wrappedValue: nil, key: "pdfAudio") var pdfAudio: URL?

    @Published(key: "currentTab") var currentTab = 0 {
        didSet { lastWebPage = savedLastWebPage[self.currentTab] }
    }

    @Published(key: "favoriteVoiceNames") var favoriteVoiceNames: [FavoriteVoiceName] = []
    @Published(key: "voiceLanguage") var voiceLanguage = "Select language"
    @Published(key: "voiceName") var voiceName = "Select voice"
    @Published(key: "isVoiceEnabled") var isVoiceEnabled = true { didSet { SpeechSynthesizer.speak() } }
    @Published(key: "voiceRate") var voiceRate = "0.4"
    @Published(key: "voiceVolume") var voiceVolume: Float = 1

    @Published var canGoBack = false
    @UserDefault(key: "lastWebPage")
    private var savedLastWebPage = ["https://google.com", "", ""]
    @Published
    var lastWebPage = "" { willSet { savedLastWebPage[self.currentTab] = newValue } }

    @Published(key: "lastPdf") var lastPdf: String = ""
    @Published(key: "lastPdfPage") var lastPdfPage = "1"

    @Published(key: "zoom") var zoom: CGFloat = 1

    @Published(key: "playbackRate") var playbackRate: Float = 1.0

    @Published(key: "bookmarks") var bookmarks: Bookmarks = []
    @Published var bookmarksCounterFilter = -1
    @Published var longmanSentences: LongmanSentences = []
    @Published var longmanSelectedBookmark = "" {
        willSet {
            longmanSentences = []
            LongmanStore.share.fetchInfo(text: newValue)
        }
    }

    @Published var longmanAudioRate: Float = 1

    private init() {
        ({ currentTab = currentTab })() // call didSet
    }
}
