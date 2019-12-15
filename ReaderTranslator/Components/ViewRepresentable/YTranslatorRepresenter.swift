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

    static var coorinator: Coordinator?
    static var pageView: WKPageView?

    @ObservedObject private var store = Store.shared
    private let defaultURL = "https://translate.yandex.ru/?lang=en-ru"

    class Coordinator: WKCoordinator {
        @Published var selectedText = TranslateAction.gTranslator(text: "")

        override init(_ parent: WKScriptsSetup) {
            super.init(parent)

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] action in
                    guard let self = self else { return }
                    let text = action.getText()
                    if text != "" {
                        print("\(self.theClassName)_$selectedText")
                        self.store.translateAction.addAll(text: text, except: .yTranslator)
                    }
                }
                .store(in: &cancellableSet)
        }
    }

    func makeCoordinator() -> Coordinator {
        makeCoordinator(coordinator: Coordinator(self))
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
                .init(name: "text", value: text),
            ]

            if let url = urlComponent.url {
                print("\(theClassName)_updateView_reload", url)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    view.load(URLRequest(url: url))
                }
            }
        }
    }

    private func getParams(url: URL?) -> (String?) {
        let url = url?.absoluteString ?? defaultURL

        guard let urlComponent = URLComponents(string: url) else { return (nil) }
        let queryItems = urlComponent.queryItems

        let lang = queryItems?.last(where: { $0.name == "lang" })?.value

        return (lang)
    }
}

extension YTranslatorRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            selectedText = .reverso(text: text)
        case "keydown":
            if event.extra?.keyCode == 18 { // Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
