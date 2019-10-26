//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct Wikipedia: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let host = "https://en.wikipedia.org/wiki/Special:Search"

    static var pageView: WKPageView?

    class Coordinator: WKCoordinator {
        var selectedText = ""

        override init(_ parent: WKScriptsSetup) {
            super.init(parent)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView(defaultUrl: host)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context: Context) {
        guard case let .wikipedia(text) = selectedText else { return }
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        guard var urlComponent = URLComponents(string: host) else { return }
        urlComponent.queryItems = [.init(name: "search", value: text)]

        if let url = urlComponent.url {
            print("\(theClassName)_updateView_reload", url.absoluteString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}

extension Wikipedia.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            self.selectedText = text
            store.translateAction.addAll(text: text, except: .wikipedia)
        case "keydown":
            if event.extra?.keyCode == 18 { //Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
