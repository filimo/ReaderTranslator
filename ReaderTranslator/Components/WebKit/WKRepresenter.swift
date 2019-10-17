//
//  WebViewRepresentable.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct WKRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var lastWebPage: String

    static var pageView: WKPageView { views[Store.shared.currentTab]! }
    static var hasSentTranslateAction = false

    @ObservedObject private var store = Store.shared
    static private var views = [Int: WKPageView]()

    class Coordinator: WKCoordinator {
        @Published var selectedText = ""
        
        override init(_ parent: WKScriptsSetup) {
            print("WKRepresenter_Coordinator_init")
            super.init(parent)
            
            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if text != "" { self.store.translateAction = .translator(text: text) }
            }
            .store(in: &cancellableSet)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> WKPageView {
        print("WebView_makeNSView")
        
        if let view = Self.views[store.currentTab] { return view }
        let view = WKPageView(defaultUrl: "")
        Self.views[self.store.currentTab] = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        store.canGoBack = view.canGoBack

        return view
    }

    func updateView(_ view: WKPageView, context: Context) {
        print("WebView_updateNSView")
        #if os(macOS)
//        TODO: view.scrollView.zoomScale = store.zoom
//        view.setNeedsDisplay(view.bounds)
        #else
        view.setZoom(zoomLevel: store.zoom)
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }
    
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString { store.lastWebPage = url.decodeUrl }
        store.canGoBack = webView.canGoBack
        webView.setZoom(zoomLevel: self.store.zoom)
    }
    
    func goBack(_ webView: WKPageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = webView.url?.absoluteString { webView.newUrl = url }
            self.store.canGoBack = webView.canGoBack
        }
    }
}

extension WKRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onSelectionChange":
            if let text = message.body as? String {
                selectedText = text
            }
            print("onSelectionChange is not implemented")
        case "onContextMenu":
            print("onContextMenu")
        case "onBodyLoaded":
            print("onBodyLoaded")
        case "onKeyDown":
            if let code = message.body as? Int {
                if code == 18 { SpeechSynthesizer.speak(text: selectedText, stopSpeaking: true, isVoiceEnabled: true) }
            }
            print("onKeyDown is not implemented")
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}


