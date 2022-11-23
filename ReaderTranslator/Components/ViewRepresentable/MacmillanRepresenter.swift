//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct MacmillanRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.macmillandictionary.com/dictionary/british/"

    static var pageView: WKPageView?

    func makeCoordinator() -> WKCoordinator {
        WKCoordinator(self, currentView: .macmillan)
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
        guard case var .macmillan(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        if let url = URL(string: urlString.encodeUrl) {
            print("\(theClassName)_updateView_reload", urlString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}
