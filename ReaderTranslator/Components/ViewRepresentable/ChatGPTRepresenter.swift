//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct ChatGPTRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction

    static var pageView: WKPageView?

    @ObservedObject private var store = Store.shared
    private let defaultURL = "https://chat.openai.com/chat"

    func makeCoordinator() -> WKCoordinator {
        WKCoordinator(self, currentView: .yTranslator)
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        view.load(urlString: defaultURL)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context _: Context) {
        if case let .chatGPT(text) = selectedText {
            Store.shared.translateAction.next()

            print("\(theClassName)_updateView_update", text)

            view.evaluateJavaScript("document.querySelector('textarea').value = '\(text)'")
        }
    }

    private func getParams(url: URL?) -> String? {
        let url = url?.absoluteString ?? defaultURL

        guard let urlComponent = URLComponents(string: url) else { return nil }
        let queryItems = urlComponent.queryItems

        let lang = queryItems?.last(where: { $0.name == "lang" })?.value

        return (lang)
    }
}
