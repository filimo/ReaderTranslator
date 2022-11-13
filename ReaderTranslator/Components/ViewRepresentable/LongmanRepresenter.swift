//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct LongmanRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.ldoceonline.com/dictionary/"

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .longman))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        loadWithRuleList(urlString: defaultURL, view: view, file: "longman")

        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        setupScript(view: view, file: "longman")

        return view
    }

    @MainActor func updateView(_ view: WKPageView, context _: Context) {
        guard case var .longman(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        print("\(theClassName)_updateView_reload", urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadWithRuleList(urlString: urlString.encodeUrl, view: view, file: "longman")
        }
    }
}
