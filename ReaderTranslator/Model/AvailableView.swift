//
//  AvailableView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 26/10/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

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

    var text: String {
        rawValue
    }

    var width: Binding<String> {
        Binding<String>(
            get: { "\(ViewsStore.shared.viewWidth[self] ?? 500)" },
            set: {
                ViewsStore.shared.viewWidth[self] = $0.cgFloatValue
            }
        )
    }

    var order: Binding<String> {
        Binding<String>(
            get: { "\(ViewsStore.shared.viewOrder[self] ?? 0)" },
            set: {
                ViewsStore.shared.viewOrder[self] = $0.intValue
            }
        )
    }

    var orderInt: Int {
        order.wrappedValue.intValue
    }

    var view: some View {
        switch self {
        case .wikipedia:
            return WikipediaView().any
        case .reverso:
            return ReversoView().any
        case .gTranslator:
            return GTranslatorView().any
        case .yTranslator:
            return YTranslatorView().any
        case .longman:
            return LongmanView().any
        case .macmillan:
            return MacmillanView().any
        case .collins:
            return CollinsView().any
        case .bookmarks:
            return BookmarksView().any
        case .pdf:
            return ReaderView_Pdf().any
        case .web:
            return ReaderView_Web().any
        case .safari:
            return SafariView().any
        }
    }

    static var resiableViews: [Self] {
        let views: [Self] = [
            .bookmarks,
            .wikipedia,
            .macmillan,
            .collins,
            .longman,
            .reverso,
            .yTranslator,
            .gTranslator,
            .pdf,
            .web
        ]
        return views.sorted { $0.orderInt < $1.orderInt }
    }

    func getAction(text: String = Store.shared.translateAction.getText()) -> TranslateAction {
        switch self {
        case .wikipedia: return .wikipedia(text: text)
        case .reverso: return .reverso(text: text)
        case .gTranslator: return .gTranslator(text: text)
        case .yTranslator: return .yTranslator(text: text)
        case .longman: return .longman(text: text)
        case .macmillan: return .macmillan(text: text)
        case .collins: return .collins(text: text)
        case .bookmarks: return .bookmarks(text: text)
        case .pdf, .web, .safari: return .none(text: text)
        }
    }
}
