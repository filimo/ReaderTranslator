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
        self.rawValue
    }

    var width: Binding<String> {
        Binding<String>(
            get: { "\(Store.shared.viewWidth[self] ?? 500)" },
            set: {
                Store.shared.viewWidth[self] = $0.cgFloatValue
            }
        )
    }

    var order: Binding<String> {
        Binding<String>(
            get: { "\(Store.shared.viewOrder[self] ?? 0)" },
            set: {
                Store.shared.viewOrder[self] = $0.intValue
            }
        )
    }

    var orderInt: Int {
        self.order.wrappedValue.intValue
    }

    var view: some View {
        switch self {
        case .wikipedia:
            return AnyView(WikipediaView())
        case .reverso:
            return AnyView(ReversoView())
        case .gTranslator:
            return AnyView(GTranslatorView())
        case .yTranslator:
            return AnyView(YTranslatorView())
        case .longman:
            return AnyView(LongmanView())
        case .macmillan:
            return AnyView(MacmillanView())
        case .collins:
            return AnyView(CollinsView())
        case .bookmarks:
            return AnyView(BookmarksView())
        case .pdf:
            return AnyView(ReaderView_Pdf())
        case .web:
            return AnyView(ReaderView_Web())
        case .safari:
            return AnyView(SafariView())
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
