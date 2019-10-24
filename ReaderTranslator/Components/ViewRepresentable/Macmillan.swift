//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct Macmillan : ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let host = "https://www.macmillandictionary.com/dictionary/british/"

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
    
    func makeView(context: Context) -> WKPageView  {
        if let view = Self.pageView { return view }

        let view = WKPageView(defaultUrl: host)
        Self.pageView = view
        
        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: WKPageView, context: Context) {
        guard case let .macmillan(text) = selectedText else { return }
        selectedText.setNone()

        print("\(theClassName)_updateView_update", text)
        
        let search = text.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(host)\(search)"
        
        if view.url?.absoluteString == urlString { return }
        
        if let url = URL(string: urlString.encodeUrl) {
            print("\(theClassName)_updateView_reload", urlString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}

extension Macmillan.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            self.selectedText = text
            store.translateAction = .translator(text: text, noReverso: true)
        case "keydown":
            if event.extra?.keyCode == 18 { //Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}



