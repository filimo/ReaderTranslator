//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import SwiftUI

enum ViewMode: String, Codable {
    case pdf = "PDF"
    case web = "WEB"
    case safari = "Safari"
}

enum TranslateAction: Equatable {
    case none(text: String = "")
    case reverso(text: String)
    case translator(text: String, noReverso: Bool = false)

    func getText() -> String {
        switch self {
        case .none(let text): return text.trimmingCharacters(in: .whitespaces)
        case .reverso(let text): return text.trimmingCharacters(in: .whitespaces)
        case .translator(let text, _): return text.trimmingCharacters(in: .whitespaces)
        }
    }
    
    mutating func setNone() {
        self = .none(text: getText())
    }
}

class Store: ObservableObject {
    static var shared = Store()
    
    @Published(key: "canSafariSendSelectedText") var canSafariSendSelectedText: Bool = true
    @Published var translateAction: TranslateAction = .none(text: "") {
        didSet {
            if case .translator(_) = translateAction { SpeechSynthesizer.speak() }
        }
    }

    
    @Published var currentPage = "1"
    @Published var pageCount = 0

    @Published(key: "currentTab") var currentTab = 0 {
        didSet { self.lastWebPage = self.savedLastWebPage[self.currentTab] }
    }
    
    @Published(key: "viewMode") var viewMode = ViewMode.pdf

    @Published(key: "favoriteVoiceNames") var favoriteVoiceNames: [FavoriteVoiceName] = []
    @Published(key: "voiceLanguage") var voiceLanguage = "Select language"
    @Published(key: "voiceName")  var voiceName = "Select voice"
    @Published(key: "isVoiceEnabled") var isVoiceEnabled = true { didSet { SpeechSynthesizer.speak() } }
    @Published(key: "voiceRate")  var voiceRate = "0.4"

    @Published var canGoBack = false
    @UserDefault(key: "lastWebPage")
    private var savedLastWebPage = ["https://google.com", "", ""]
    @Published
    var lastWebPage = "" { willSet { self.savedLastWebPage[self.currentTab] = newValue } }
    
    @Published(key: "lastPdfPage") var lastPdfPage = "1"

    @Published(key: "zoom") var zoom: CGFloat = 1

    @Published(key: "bookmarks") var bookmarks: [String] = []

    private init() {
        ({ currentTab = currentTab })() //call didSet
    }
}
