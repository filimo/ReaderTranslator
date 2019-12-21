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
    @ObservedObject var webStore = WebStore.shared

    var cancellableSet: Set<AnyCancellable> = []

    init(_ parent: WKScriptsSetup) {
        self.parent = parent
        super.init()
        print("\(theClassName)_makeCoordinator")
    }

    deinit {
        cancellableSet.cancelAndRemoveAll()
    }

    func getEvent(data: Any) -> DOMEvent? {
        if let string = data as? String {
            do {
                return try JSONDecoder().decode(DOMEvent.self, from: Data(string.utf8))
            } catch {
                print(error.localizedDescription)
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
        print(error)
    }
}

extension WKCoordinator: WKCoordinatorNavigationDelegate {
    func goBack(_ webView: WKWebView) {
        if let webView = webView as? WKPageView { parent.goBack(webView) }
    }
}
