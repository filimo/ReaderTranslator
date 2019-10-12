//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReversoContext : ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let host = "https://context.reverso.net/translation/"

    static var pageView: WKPageView?
    static var hasSentTranslateAction = false

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
        print("ReversoContext_makeView")
        if let view = Self.pageView { return view }
        
        let view = WKPageView(defaultUrl: host)
        Self.pageView = view
        
        setupScripts(view: view, coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: WKPageView, context: Context) {
        guard case let .reversoContext(text) = selectedText else { return }
        selectedText = .none

        print("ReversoContext_updateView")
        
        let search = text.replacingOccurrences(of: " ", with: "+")
        let language = view.url?.absoluteString.groups(for: #"\/translation\/(.+)\/"#)[safe: 0]?[safe: 1] ?? "english-russian"
        let urlString = "\(host)\(language)/\(search)"
        
        if view.url?.absoluteString == urlString { return }
        
        if let url = URL(string: urlString) {
            print("ReversoContext_updateView_reload", urlString)
            view.load(URLRequest(url: url))
        }
    }
}

extension ReversoContext.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onSelectionChange":
            if let value = message.body as? String {
                self.selectedText = value
            }
        case "onContextMenu":
            print("onContextMenu")
        case "onBodyLoaded":
            print("onBodyLoaded")
        case "onKeyDown":
            if let code = message.body as? Int {
                if code == 17 { //Ctrl
                    store.translateAction = .translator(text: self.selectedText, noReversoContext: true)
                }
                if code == 18 { //Alt
                    SpeechSynthesizer.speak(text: self.selectedText, stopSpeaking: true, isVoiceEnabled: true)
                }
            }
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}



