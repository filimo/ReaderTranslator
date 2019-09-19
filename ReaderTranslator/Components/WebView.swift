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

struct WebView: UIViewControllerRepresentable {
    @Binding var url: String
    @EnvironmentObject var store: Store

    func makeUIViewController(context: Context) -> WebViewController {
        WebViewController(store: store)
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        uiViewController.webView.scrollView.zoomScale = store.zoom
        print("@Binding var url: ", url)
        if uiViewController.url != url {
            uiViewController.load(url: url)
        }
    }
}

class WebViewController: UIViewController {
    @Published var url: String = ""
    @Published var store: Store
    @Published var selectedText = ""

    private let script = """
        document.onselectionchange = function() {
            var txt = document.getSelection().toString()
            
            webkit.messageHandlers.onSelectionChange.postMessage(txt)
        }
        document.body.oncontextmenu = function() {
            var txt = document.getSelection().toString()
            
            webkit.messageHandlers.onContextMenu.postMessage("txt")
        }
    """
    lazy var webView: WKWebView = {
        let contentController = WKUserContentController();
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add(self, name: "onSelectionChange")
        contentController.add(self, name: "onContextMenu")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        return WKWebView(frame: self.view.frame, configuration: config)
    }()

    init(store: Store) {
        self.store = store
        
        super.init(nibName: nil, bundle: nil)
        
        _ = $selectedText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if text != "" {
                    self.store.selectedText = text
                }
            }
        
        _ = $url
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { url in
                if let url = URL(string: url) {
                    self.webView.load(URLRequest(url: url))
                }
            }
    }
    
    func load(url: String) {
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = self.webView
        
        self.webView.navigationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WebViewController: WKScriptMessageHandler {
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
    }
}

extension WebViewController: WKNavigationDelegate {
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
