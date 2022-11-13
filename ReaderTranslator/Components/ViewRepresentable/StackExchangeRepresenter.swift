//
//  StackExchangeRepresenter.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 28/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct StackExchangeRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://english.stackexchange.com/search"

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .stackExchange))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        view.load(urlString: defaultURL)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    @MainActor func updateView(_ view: WKPageView, context _: Context) {
        guard case let .stackExchange(text) = selectedText else { return }
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: "\n", with: "+").replacingOccurrences(of: " ", with: "+")
        guard var urlComponent = URLComponents(string: defaultURL) else { return }
        urlComponent.queryItems = [
            .init(name: "q", value: search)
        ]

        if let url = urlComponent.url {
            print("\(theClassName)_updateView_reload", url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}
