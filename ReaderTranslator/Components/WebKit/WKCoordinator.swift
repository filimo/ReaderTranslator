
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
        case "onKeyDown":
            if let code = message.body as? String {
                if code == "MetaLeft" { SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true) }
            }
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}

extension WKCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == self.store.lastWebPage {
                decisionHandler(.allow)
            }else{
                Safari.openSafari(url)
                decisionHandler(.cancel)
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webView = webView as? WKPageView { parent.webView(webView, didFinish: navigation) }        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        guard navigationAction.targetFrame?.isMainFrame == true else {
            decisionHandler(.allow, preferences)
            return
        }
        decisionHandler(.allow, preferences)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}

extension WKCoordinator: WKCoordinatorNavigationDelegate {    
    func goBack(_ webView: WKWebView) {
        if let webView = webView as? WKPageView { parent.goBack(webView) }
    }
}
