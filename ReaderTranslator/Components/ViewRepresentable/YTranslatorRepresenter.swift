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

struct YTranslatorRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    @ObservedObject private var store = Store.shared
    private let defaultURL = "https://translate.yandex.ru/?lang=en-ru"

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .yTranslator))
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
        if case let .yTranslator(text) = selectedText {
            Store.shared.translateAction.next()

            print("\(theClassName)_updateView_update", text)

            let lang = getParams(url: view.url)
            guard var urlComponent = URLComponents(string: defaultURL) else { return }
            urlComponent.queryItems = [
                .init(name: "lang", value: lang),
                .init(name: "text", value: text)
            ]

            if let url = urlComponent.url {
                print("\(theClassName)_updateView_reload", url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    view.load(URLRequest(url: url))
                }
            }
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
