//
//  MerriamWebsterRepresenter.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct MerriamWebsterRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.merriam-webster.com/dictionary/"

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .merriamWebster))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        loadWithRuleList(urlString: defaultURL, view: view, file: "merriam-webster")
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context _: Context) {
        guard case var .merriamWebster(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let urlString = "\(defaultURL)\(text)"

        if view.url?.absoluteString == urlString { return }

        print("\(theClassName)_updateView_reload", urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadWithRuleList(urlString: urlString, view: view, file: "merriam-webster")
        }
    }
}
