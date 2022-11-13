//
//  DeepLRepresenter.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/3/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct DeepLRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.deepl.com/en/translator#en/ru/"

    static var coorinator: WKCoordinator?
    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        makeCoordinator(coordinator: WKCoordinator(self, currentView: .deepL))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        if let url = URL(string: defaultURL) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                view.load(URLRequest(url: url))
            }
        }
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        setupScript(view: view, file: "deep-L")

        return view
    }

    @MainActor func updateView(_ view: WKPageView, context _: Context) {
        guard case var .deepL(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.encodeUrl
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        if let url = URL(string: urlString) {
            print("\(theClassName)_updateView_reload", urlString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}
