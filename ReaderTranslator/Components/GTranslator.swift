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

struct GTranslator : ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction

    static var pageView: WKPageView?

    @ObservedObject private var store = Store.shared
    private let defaultUrl = "https://translate.google.com?op=translate&sl=auto&tl=ru"

    class Coordinator: WKCoordinator {
        @Published var selectedText = TranslateAction.translator(text: "")
        
        override init(_ parent: WKScriptsSetup) {
            super.init(parent)

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { action in
                    let text = action.getText()
                    if text != "" {
                        print("Translator_$selectedText")
                        SpeechSynthesizer.speak(text: text)
                        self.store.translateAction = .reversoContext(text: text)
                    }
                }
                .store(in: &cancellableSet)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> WKPageView  {
        print("Translator_makeView")
        if let view = Self.pageView { return view }
        
        let view = WKPageView(defaultUrl: defaultUrl)
        Self.pageView = view
        
        setupScripts(view: view, coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: WKPageView, context: Context) {
        if case let .translator(text, noReversoContext) = selectedText,
            text != "" {
            selectedText.setNone()

            print("Translator_updateView", noReversoContext, text)
            
            let (sl, tl) = getParams(url: view.url)
            guard var urlComponent = URLComponents(string: defaultUrl) else { return }
            urlComponent.queryItems = [
                .init(name: "op", value: "translate"),
                .init(name: "sl", value: sl),
                .init(name: "tl", value: tl),
                .init(name: "text", value: text)
            ]
            
            if let url = urlComponent.url {
                print("Translator_updateView_reload", url)
                view.load(URLRequest(url: url))
            }
            
            if noReversoContext != true, text.split(separator: " ").count < 10 {
                self.store.translateAction = .reversoContext(text: text)
            }
        }
    }
    
    private func getParams(url: URL?) -> (String?, String?) {
        let lastUrl = url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultUrl
        
        guard let urlComponent = URLComponents(string: url) else { return (nil, nil) }
        let queryItems = urlComponent.queryItems

        selectedText.setNone()
        
        let sl = queryItems?.last(where: { $0.name == "sl" })?.value
        let tl = queryItems?.last(where: { $0.name == "tl" })?.value
        
        return (sl, tl)
    }
}

extension GTranslator.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onSelectionChange":
            if let text = message.body as? String {
                selectedText = .reversoContext(text: text)
            }
        case "onContextMenu":
            print("onContextMenu")
        case "onBodyLoaded":
            print("onBodyLoaded")
        case "onKeyDown":
            if let code = message.body as? Int {
                if code == 18 { SpeechSynthesizer.speak(text: selectedText.getText(), stopSpeaking: true, isVoiceEnabled: true) }
            }
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}




