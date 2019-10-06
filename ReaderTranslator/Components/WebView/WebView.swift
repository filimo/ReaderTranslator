//
//  WebView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct WebView: ViewRepresentable {
    @Binding var lastWebPage: String

    static var pageView: PageWebView { views[Store.shared.currentTab]! }
    
    @ObservedObject private var store = Store.shared
    static private var views = [Int: PageWebView]()

    class Coordinator: NSObject {
        private let parent: WebView
        private var store = Store.shared
        
        @Published var selectedText = ""

        private var cancellableSet: Set<AnyCancellable> = []
        
        init(_ parent: WebView) {
            self.parent = parent
            
            super.init()
            
            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if text != "" { self.store.selectedText = text }
                }
                .store(in: &cancellableSet)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> PageWebView {
        print("WebView_makeNSView")
        
        if let view = Self.views[store.currentTab] { return view }
        let view = PageWebView(defaultUrl: "")
        
        let userContentController = view.configuration.userContentController


        #if os(macOS)
        view.allowsMagnification = true
        #endif
        view.navigationDelegate = context.coordinator
        
        userContentController.add(context.coordinator, name: "onSelectionChange")
        userContentController.add(context.coordinator, name: "onContextMenu")
        userContentController.add(context.coordinator, name: "onBodyLoaded")
        userContentController.add(context.coordinator, name: "onKeyPress")
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(userScript)
        
        Self.views[self.store.currentTab] = view
        store.canGoBack = view.canGoBack

        return view
    }

    func updateView(_ view: PageWebView, context: Context) {
        print("WebView_updateNSView")
        #if os(macOS)
//        TODO: view.scrollView.zoomScale = store.zoom
//        view.setNeedsDisplay(view.bounds)
        #else
        view.setZoom(zoomLevel: store.zoom)
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }
}

private let script = """
    document.onselectionchange = function() {
        var txt = document.getSelection().toString()
        
        webkit.messageHandlers.onSelectionChange.postMessage(txt)
    }
    window.oncontextmenu = function() {
        var txt = document.getSelection().toString()
        
        webkit.messageHandlers.onContextMenu.postMessage("txt")
    }
    document.body.onload = function() {
        webkit.messageHandlers.onBodyLoaded.postMessage("txt")
    }
    document.body.onkeydown = function(event) {
        webkit.messageHandlers.onKeyPress.postMessage(event.code)
    }
"""

extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "onSelectionChange":
            if let value = message.body as? String {
                selectedText = value
            }
        case "onContextMenu":
            print("onContextMenu")
        case "onBodyLoaded":
            print("onBodyLoaded")
        case "onKeyPress":
            if let code = message.body as? String {
                if code == "MetaLeft" { SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true) }
            }
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}

extension WebView.Coordinator: WKNavigationDelegate {
    private func webView(_ webView: PageWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == self.store.lastWebPage {
                decisionHandler(.allow)
            }else{
                PageWebView.open(url)
                decisionHandler(.cancel)
            }
        }
    }

    private func webView(_ webView: PageWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString { store.lastWebPage = url.decodeUrl }
        store.canGoBack = webView.canGoBack

        webView.setZoom(zoomLevel: self.store.zoom)
    }

    private func webView(_ webView: PageWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        guard navigationAction.targetFrame?.isMainFrame == true else {
            decisionHandler(.allow, preferences)
            return
        }
        decisionHandler(.allow, preferences)
    }

    private func webView(_ webView: PageWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}


