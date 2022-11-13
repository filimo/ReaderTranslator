//
//  Collins.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct CambidgeRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://dictionary.cambridge.org/dictionary/english-russian/"

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .cambridge))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        view.load(urlString: defaultURL)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        setupScript(view: view, file: "cambridge")

        return view
    }

    @MainActor func updateView(_ view: WKPageView, context _: Context) {
        guard case var .collins(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        print("\(theClassName)_updateView_reload", urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadWithRuleList(urlString: urlString, view: view, file: "cambridge")
        }
    }
}

