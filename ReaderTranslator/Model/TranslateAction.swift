//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

private var stack = Stack<TranslateAction>()

@MainActor
enum TranslateAction: Equatable {
    case none(text: String)
    case speak(text: String)
    case merriamWebster(text: String)
    case stackExchange(text: String)
    case reverso(text: String)
    case gTranslator(text: String)
    case deepL(text: String)
    case yTranslator(text: String)
    case longman(text: String)
    case macmillan(text: String)
    case collins(text: String)
    case cambridge(text: String)
    case wikipedia(text: String)
    case bookmarks(text: String)
    case chatGPT(text: String)

    init() {
        self = .none(text: "")
    }

    @MainActor func getText() -> String {
        switch self {
        case let .none(text),
             let .speak(text),
             let .merriamWebster(text),
             let .stackExchange(text),
             let .reverso(text),
             let .gTranslator(text),
             let .deepL(text),
             let .yTranslator(text),
             let .longman(text),
             let .macmillan(text),
             let .collins(text),
             let .cambridge(text),
             let .bookmarks(text),
             let .wikipedia(text),
             let .chatGPT(text):
            return text
                .trimmingCharacters(in: .whitespaces)
        }
    }

    mutating func add(_ actions: [TranslateAction], isSpeaking: Bool = true) {
        guard Store.shared.enabledClipboard else { return }
        
        let isEmpty = stack.count == 0 ? true : false

        for action in actions {
            if case .none = action { continue }
            stack.push(action)
        }
        if isSpeaking { stack.push(.speak(text: actions.first?.getText() ?? "")) }
        if isEmpty { next() }
    }

    mutating func add(_ action: TranslateAction, isSpeaking: Bool = true) {
        guard Store.shared.enabledClipboard else { return }
        
        add([action], isSpeaking: isSpeaking)
    }

    mutating func addAll(text: String, except: AvailableView? = nil, isSpeaking: Bool = true) {
        guard Store.shared.enabledClipboard else { return }

        let actions = ViewsStore.shared.enabledViews
            .filter {
                guard $0 != except else { return false }

                let count = text.split(separator: " ").count
                switch $0 {
                case .collins,
                     .cambridge,
                     .merriamWebster,
                     .stackExchange,
                     .longman,
                     .macmillan,
                     .wikipedia: if count < 4 { return true }
                case .reverso: if count < 10 { return true }
                case .gTranslator, .deepL, .yTranslator, .bookmarks, .chatGPT: return true
                case .audioToText, .pdf, .web, .safari: return false
                }
                return false
            }
            .map { $0.getAction(text: text) }
        add(actions, isSpeaking: isSpeaking)
    }

    @discardableResult
    mutating func next() -> TranslateAction {
        if let action = stack.pop() {
            self = action
        } else {
            self = .none(text: getText())
        }
        return self
    }
}
