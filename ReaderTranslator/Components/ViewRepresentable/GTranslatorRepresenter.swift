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

struct GTranslatorRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    static var isMiniMode: Bool = false {
        didSet { setMiniMode() }
    }

    static var pageView: WKPageView?

    @ObservedObject private var store = Store.shared
    private let defaultURL = "https://translate.google.com?op=translate&sl=auto&tl=ru"

    func makeCoordinator() -> WKCoordinator {
        WKCoordinator(self, currentView: .gTranslator)
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        view.load(urlString: defaultURL)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        setupScript(view: view, file: "gtranslator-reverso-speaker")
        setupScript(view: view, file: "gtranslator")
        Self.setMiniMode()

        return view
    }

    func updateView(_ view: WKPageView, context _: Context) {
        if case let .gTranslator(text) = selectedText {
            Store.shared.translateAction.next()

            print("\(theClassName)_updateView_update", text)

            let (slValue, tlValue) = getParams(url: view.url)
            guard var urlComponent = URLComponents(string: defaultURL) else { return }
            urlComponent.queryItems = [
                .init(name: "op", value: "translate"),
                .init(name: "sl", value: slValue),
                .init(name: "tl", value: tlValue),
                .init(name: "text", value: text)
            ]

            if let url = urlComponent.url {
                print("\(Self.self)_updateView_reload", url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    view.load(URLRequest(url: url))
                }
            }
        }
    }

    private func getParams(url: URL?) -> (String?, String?) {
        let lastUrl = url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultURL

        guard let urlComponent = URLComponents(string: url) else { return (nil, nil) }
        let queryItems = urlComponent.queryItems

        let slValue = queryItems?.last(where: { $0.name == "sl" })?.value
        let tlValue = queryItems?.last(where: { $0.name == "tl" })?.value

        return (slValue, tlValue)
    }
    
    static private func setMiniMode() {
        let mode = isMiniMode ? "mini" : "full"
        GTranslatorRepresenter.pageView?.evaluateJavaScript("readerTranslatorMode('\(mode)')")
    }
}

