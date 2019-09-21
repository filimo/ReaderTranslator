//
//  WebView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine
import WebKit
import SafariServices

struct WebView: UIViewRepresentable {
    @Binding var lastWebPage: String
    @Binding var zoom: CGFloat

    func makeUIView(context: Context) -> PageWebView {
        PageWebView()
    }

    func updateUIView(_ uiView: PageWebView, context: Context) {
        uiView.scrollView.zoomScale = self.zoom
        if uiView.newUrl != self.lastWebPage { uiView.newUrl = self.lastWebPage }
    }
}

class PageWebView: WKWebView {
    @Published private var selectedText = ""
    @Published var newUrl = ""

    typealias UIViewType = PageWebView
    
    var store = Store.shared
    
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
    """
    
    init() {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        config.userContentController = contentController
        config.websiteDataStore = .nonPersistent()
        
        super.init(frame: .zero, configuration: config)

//        cleanAllCookies()

        self.navigationDelegate = self
        
        contentController.addUserScript(userScript)
        contentController.add(self, name: "onSelectionChange")
        contentController.add(self, name: "onContextMenu")
        contentController.add(self, name: "onBodyLoaded")


        _ = $selectedText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if text != "" {
                    self.store.selectedText = text
                }
            }
        
        _ = $newUrl
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { url in
                if let url = URL(string: url) {
                    self.load(URLRequest(url: url))
                }
            }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }
}

extension PageWebView: WKScriptMessageHandler {
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
        default:
            print("webkit.messageHandlers.\(message.name).postMessage() isn't found")
        }
    }
}

extension PageWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == self.store.lastWebPage {
                decisionHandler(.allow)
            }else{
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //TODO: it's the hack it need research the issue why zoom doesn't work just after a page is loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollView.zoomScale = self.store.zoom
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        guard navigationAction.targetFrame?.isMainFrame == true else {
            decisionHandler(.allow, preferences)
            return
        }
        decisionHandler(.allow, preferences)
    }
}

