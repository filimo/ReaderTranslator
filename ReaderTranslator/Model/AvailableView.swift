//
//  AvailableView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

enum AvailableView: String, Codable, CaseIterable {
    case bookmarks = "Bookmarks"
    case wikipedia = "Wikipedia"
    case reverso = "Reverso"
    case gTranslator = "GTranslator"
    case yTranslator = "YTranslator"
    case longman = "Longman"
    case macmillan = "Macmillan"
    case collins = "Collin's"
    case pdf = "PDF"
    case web = "Web"
    case safari = "Safari"

    func getAction(text: String = Store.shared.translateAction.getText()) -> TranslateAction {
        switch self {
        case .wikipedia:
            return .wikipedia(text: text)
        case .reverso:
            return .reverso(text: text)
        case .gTranslator:
            return .gTranslator(text: text)
        case .yTranslator:
            return .yTranslator(text: text)
        case .longman:
            return .longman(text: text)
        case .macmillan:
            return .macmillan(text: text)
        case .collins:
            return .collins(text: text)
        case .bookmarks:
            return .bookmarks(text: text)
        case .pdf:
            return .none(text: text)
        case .web:
            return .none(text: text)
        case .safari:
            return .none(text: text)
        }
    }
}
