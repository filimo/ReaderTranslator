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
    var selectedText = ""
    private let currentView: AvailableView

    @ObservedObject var store = Store.shared
    @ObservedObject var webStore = WebStore.shared

    var cancellableSet: Set<AnyCancellable> = []

    init(_ parent: WKScriptsSetup, currentView: AvailableView) {
        self.parent = parent
        self.currentView = currentView
        super.init()
        print("\(Self.self)_makeCoordinator")
    }

    deinit {
        cancellableSet.cancelAndRemoveAll()
    }

    func getEvent(data: Any) -> DOMEvent? {
        if let string = data as? String {
            do {
                return try JSONDecoder().decode(DOMEvent.self, from: Data(string.utf8))
            } catch {
                Logger.log(type: .error, value: error)
            }
        }
        return nil
    }
}

extension WKCoordinator: WKNavigationDelegate {
    func webView(
        _: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url {
            if url.absoluteString == webStore.lastWebPage {
                decisionHandler(.allow)
            } else {
                Safari.openSafari(url)
                decisionHandler(.cancel)
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webView = webView as? WKPageView { parent.webView(webView, didFinish: navigation) }
    }

    func webView(
        _: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences,
        decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void
    ) {
        guard navigationAction.targetFrame?.isMainFrame == true else {
            decisionHandler(.allow, preferences)
            return
        }
        decisionHandler(.allow, preferences)
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError error: Error) {
        Logger.log(type: .error, value: error)
    }
}

extension WKCoordinator: WKCoordinatorNavigationDelegate {
    func goBack(_ webView: WKWebView) {
        if let webView = webView as? WKPageView { parent.goBack(webView) }
    }
}

extension WKCoordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            selectedText = text
            store.translateAction.addAll(text: text, except: currentView)
        case "keydown":
            if event.extra?.keyCode == 18 { // Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
