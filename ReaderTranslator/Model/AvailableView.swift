//
//  AvailableView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

enum AvailableView: String, Codable, CaseIterable {
    case wikipedia = "Wikipedia"
    case reverso = "Reverso"
    case gTranslator = "GTranslator"
    case yTranslator = "YTranslator"
    case longman = "Longman"
    case macmillan = "Macmillan"
    case collins = "Collin's"

    func getAction(text: String = TranslateAction.getText(Store.shared.translateAction)()) -> TranslateAction {
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
        }
    }
}
