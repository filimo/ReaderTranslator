
//
//  ViewRepresentableJavaScriptDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Combine
import SwiftUI
import WebKit


class WKCoordinator: NSObject {
    let parent: WKScriptsSetup
    @ObservedObject var store = Store.shared
    var cancellableSet: Set<AnyCancellable> = []
    
    @Published var selectedText = ""
    
    init(_ parent: WKScriptsSetup) {
        self.parent = parent
    }
}

extension WKCoordinator: WKScriptMessageHandler {
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

extension WKCoordinator: WKNavigationDelegate {
    private func webView(_ webView: WKPage, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == self.store.lastWebPage {
                decisionHandler(.allow)
            }else{
                Safari.openSafari(url)
                decisionHandler(.cancel)
            }
        }
    }

    private func webView(_ webView: WKPage, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString { store.lastWebPage = url.decodeUrl }
        store.canGoBack = webView.canGoBack

        webView.setZoom(zoomLevel: self.store.zoom)
    }

    private func webView(_ webView: WKPage, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        guard navigationAction.targetFrame?.isMainFrame == true else {
            decisionHandler(.allow, preferences)
            return
        }
        decisionHandler(.allow, preferences)
    }

    private func webView(_ webView: WKPage, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}
