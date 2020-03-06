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

    static var coorinator: Coordinator?
    static var pageView: WKPageView?

    class Coordinator: WKCoordinator {
        var selectedText = ""
    }

    func makeCoordinator() -> Coordinator {
        makeCoordinator(coordinator: Coordinator(self))
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

    func updateView(_ view: WKPageView, context _: Context) {
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

extension DeepLRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            selectedText = text
            store.translateAction.addAll(text: text, except: .deepL)
        case "keydown":
            if event.extra?.keyCode == 18 { // Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
