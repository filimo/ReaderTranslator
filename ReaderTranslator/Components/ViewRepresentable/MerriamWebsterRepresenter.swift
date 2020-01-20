//
//  MerriamWebsterRepresenter.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct MerriamWebsterRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.merriam-webster.com/dictionary/"

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
        loadWithRuleList(urlString: defaultURL, view: view, file: "merriam-webster")
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context _: Context) {
        guard case var .merriamWebster(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        if URL(string: urlString.encodeUrl) != nil {
            print("\(theClassName)_updateView_reload", urlString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadWithRuleList(urlString: urlString.encodeUrl, view: view, file: "merriam-webster")
            }
        }
    }
}

extension MerriamWebsterRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            selectedText = text
            store.translateAction.addAll(text: text, except: .macmillan)
        case "keydown":
            if event.extra?.keyCode == 18 { // Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
