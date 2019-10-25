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

enum AvailableView: String, Codable {
    case wikipedia = "Wikipedia"
    case reverso = "Reverso"
    case translator = "GTranslator"
    case longman = "Longman"
    case macmillan = "Macmillan"
    case collins = "Collin's"

    func getAction() -> TranslateAction {
        let text = TranslateAction.getText(Store.shared.translateAction)()

        switch self {
        case .wikipedia:
            return .wikipedia(text: text)
        case .reverso:
            return .reverso(text: text)
        case .translator:
            return .translator(text: text)
        case .longman:
            return .longman(text: text)
        case .macmillan:
            return .macmillan(text: text)
        case .collins:
            return .collins(text: text)
        }
    }
}

enum TranslateAction: Equatable {
    case none(text: String = "")
    case reverso(text: String)
    case translator(text: String, noReverso: Bool = false)
    case longman(text: String)
    case macmillan(text: String)
    case collins(text: String)
    case wikipedia(text: String)

    func getText() -> String {
        switch self {
        case .none(let text): return text.trimmingCharacters(in: .whitespaces)
        case .reverso(let text): return text.trimmingCharacters(in: .whitespaces)
        case .translator(let text, _): return text.trimmingCharacters(in: .whitespaces)
        case .longman(let text): return text.trimmingCharacters(in: .whitespaces)
        case .macmillan(let text): return text.trimmingCharacters(in: .whitespaces)
        case .collins(let text): return text.trimmingCharacters(in: .whitespaces)
        case .wikipedia(let text): return text.trimmingCharacters(in: .whitespaces)
        }
    }

    mutating func setNone() {
        self = .none(text: getText())
    }
}

class Store: ObservableObject {
    static var shared = Store()

    var maxViewWidth: CGFloat = 400

    @Published(key: "canSafariSendSelectedText") var canSafariSendSelectedText: Bool = true
    @Published var translateAction: TranslateAction = .none(text: "") {
        didSet {
            if case .translator(_) = translateAction { SpeechSynthesizer.speak() }
        }
    }

    @Published(key: "enabledViews") var enabledViews: Set<AvailableView> = [.reverso, .translator]

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

    var lastPdf: String = ""
    @Published(key: "lastPdfPage") var lastPdfPage = "1"

    @Published(key: "zoom") var zoom: CGFloat = 1

    @Published(key: "bookmarks") var bookmarks: [String] = []

    private init() {
        ({ currentTab = currentTab })() //call didSet
    }
}
