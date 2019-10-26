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
    case none(text: String = "")
    case speak(text: String)
    case reverso(text: String)
    case translator(text: String)
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
             .translator(let text),
             .longman(let text),
             .macmillan(let text),
             .collins(let text),
             .wikipedia(let text):
             return text.trimmingCharacters(in: .whitespaces)
        }
    }

    func none() -> TranslateAction { .none(text: getText()) }

    mutating func add(_ action: TranslateAction) {
        add([.speak(text: action.getText()), action])
        if stack.count == 1 { next() }
    }

    mutating func add(_ actions: [TranslateAction]) {
        let isEmpty = stack.count == 0 ? true : false

        for action in actions { stack.push(action) }
        stack.push(.speak(text: actions.first?.getText() ?? ""))
        if isEmpty { next() }
    }

    mutating func addAll(text: String, except: AvailableView? = nil) {
        let actions = Store.shared.enabledViews
            .filter { $0 != except }
            .map { $0.getAction(text: text) }
        add(actions)
    }

    @discardableResult
    mutating func next() -> TranslateAction {
        self = stack.count == 0 ? .none() : stack.pop()
        return self
    }
}
