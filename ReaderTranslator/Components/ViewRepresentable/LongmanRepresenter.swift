//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct LongmanRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://www.ldoceonline.com/dictionary/"

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
        self.loadWithRuleList(urlString: defaultURL, view: view, file: "longman")

        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context: Context) {
        guard case var .longman(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        let search = text.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        if view.url?.absoluteString == urlString { return }

        print("\(theClassName)_updateView_reload", urlString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadWithRuleList(urlString: urlString.encodeUrl, view: view, file: "longman")
        }
    }
}

extension LongmanRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            self.selectedText = text
            store.translateAction.addAll(text: text, except: .longman)
        case "keydown":
            if event.extra?.keyCode == 18 { //Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}