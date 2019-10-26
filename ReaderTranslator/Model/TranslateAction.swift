//
//  File.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

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
