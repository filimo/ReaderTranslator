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
    case merriamWebster = "Merriam-Webster"
    case stackExchange = "StackExchange"
    case reverso = "Reverso"
    case gTranslator = "GTranslator"
    case deepL = "DeepL"
    case yTranslator = "YTranslator"
    case longman = "Longman"
    case macmillan = "Macmillan"
    case collins = "Collin's"
    case cambridge = "Cambridge"
    case pdf = "PDF"
    case web = "Web"
    case safari = "Safari"
}

extension AvailableView {
    var text: String {
        rawValue
    }

    var width: Binding<CGFloat> {
        Binding<CGFloat>(
            get: {
                ViewsStore.shared.viewWidth[self] ?? ViewsStore.defaultWidth
            },
            set: {
                ViewsStore.shared.viewWidth[self] = $0
            }
        )
    }

    var order: Binding<Int> {
        Binding<Int>(
            get: {
                ViewsStore.shared.viewOrder[self] ?? 0
            },
            set: {
                ViewsStore.shared.viewOrder[self] = $0
            }
        )
    }

    var orderInt: Int {
        ViewsStore.shared.viewOrder[self] ?? 0
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .wikipedia: WikipediaView()
        case .merriamWebster: MerriamWebsterView()
        case .stackExchange: StackExchangeView()
        case .reverso: ReversoView()
        case .gTranslator: GTranslatorView()
        case .deepL: DeepLView()
        case .yTranslator: YTranslatorView()
        case .longman: LongmanView()
        case .macmillan: MacmillanView()
        case .collins: CollinsView()
        case .cambridge: CambidgeView()
        case .bookmarks: BookmarksView()
        case .pdf: ReaderView_Pdf()
        case .web: ReaderView_Web()
        case .safari: SafariView()
        }
    }

    static var resiableViews: [Self] {
        let views: [Self] = [
            .bookmarks,
            .wikipedia,
            .macmillan,
            .collins,
            .merriamWebster,
            .stackExchange,
            .longman,
            .cambridge,
            .reverso,
            .yTranslator,
            .gTranslator,
            .deepL,
            .pdf,
            .web
        ]
        return views.sorted { $0.orderInt < $1.orderInt }
    }

    var isEnabled: Bool {
        ViewsStore.shared.enabledViews.contains(self)
    }

    func getAction(text: String = Store.shared.translateAction.getText()) -> TranslateAction {
        switch self {
        case .wikipedia: return .wikipedia(text: text)
        case .merriamWebster: return .merriamWebster(text: text)
        case .stackExchange: return .stackExchange(text: text)
        case .reverso: return .reverso(text: text)
        case .gTranslator: return .gTranslator(text: text)
        case .deepL: return .deepL(text: text)
        case .yTranslator: return .yTranslator(text: text)
        case .longman: return .longman(text: text)
        case .macmillan: return .macmillan(text: text)
        case .collins: return .collins(text: text)
        case .cambridge: return .collins(text: text)
        case .bookmarks: return .bookmarks(text: text)
        case .pdf, .web, .safari: return .none(text: text)
        }
    }
}
