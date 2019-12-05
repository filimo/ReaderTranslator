//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

private var stack = Stack<TranslateAction>()

enum TranslateAction: Equatable {
    case none(text: String)
    case speak(text: String)
    case reverso(text: String)
    case gTranslator(text: String)
    case yTranslator(text: String)
    case longman(text: String)
    case macmillan(text: String)
    case collins(text: String)
    case wikipedia(text: String)

    init() {
        self = .none(text: "")
    }

    func getText() -> String {
        switch self {
        case .none(let text),
             .speak(let text),
             .reverso(let text),
             .gTranslator(let text),
             .yTranslator(let text),
             .longman(let text),
             .macmillan(let text),
             .collins(let text),
             .wikipedia(let text):
            return text
                .trimmingCharacters(in: .whitespaces)
        }
    }

    mutating func add(_ action: TranslateAction, isSpeaking: Bool = true) {
        if isSpeaking { add([.speak(text: action.getText()), action]) }
        if stack.count == 1 { next() }
    }

    mutating func add(_ actions: [TranslateAction], isSpeaking: Bool = true) {
        let isEmpty = stack.count == 0 ? true : false

        for action in actions { stack.push(action) }
        if isSpeaking { stack.push(.speak(text: actions.first?.getText() ?? "")) }
        if isEmpty { next() }
    }

    mutating func addAll(text: String, except: AvailableView? = nil, isSpeaking: Bool = true) {
        let actions = Store.shared.enabledViews
            .filter {
                guard $0 != except else { return false }

                let count = text.split(separator: " ").count
                switch $0 {
                case .collins,
                     .longman,
                     .macmillan,
                     .wikipedia: if count < 4 { return true }
                case .reverso: if count < 10 { return true }
                case .gTranslator, .yTranslator: return true
                case .bookmarks: return false
                }
                return false
            }
            .map { $0.getAction(text: text) }
        add(actions, isSpeaking: isSpeaking)
    }

    @discardableResult
    mutating func next() -> TranslateAction {
        self = stack.count == 0 ? .none(text: getText()) : stack.pop()
        return self
    }
}
