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
    @Binding var url: String
    @EnvironmentObject var store: Store
    
    func makeUIView(context: Context) -> CustomWebView {
        CustomWebView()
    }

    func updateUIView(_ uiView: CustomWebView, context: Context) {
        uiView.scrollView.zoomScale = store.zoom
        if uiView.newUrl != url { uiView.newUrl = url }
    }
}

class CustomWebView: WKWebView {
    @Published private var selectedText = ""
    @Published var newUrl = ""

    typealias UIViewType = CustomWebView
    
    var store = Store.shared
    
    private let script = """
        document.onselectionchange = function() {
            var txt = document.getSelection().toString()
            
            webkit.messageHandlers.onSelectionChange.postMessage(txt)
        }
        document.body.oncontextmenu = function() {
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
        
        super.init(frame: .zero, configuration: config)
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
}

extension CustomWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "onSelectionChange") {
            if let text = message.body as? String {
                selectedText = text
            }
        }
        if(message.name == "onContextMenu") {
            if let text = message.body as? String {
                SpeechSynthesizer.speech(text: text, voiceName: store.voiceName)
            }
        }
        if(message.name == "onBodyLoaded") {
            self.scrollView.zoomScale = self.store.zoom
        }
    }
}

extension CustomWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == store.lastWebPage {
                decisionHandler(.allow)
            }else{
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            }
        }
    }
}

