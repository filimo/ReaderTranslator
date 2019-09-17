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
        print("@Binding var url: ", url)
        if uiViewController.url != url {
            uiViewController.load(url: url)
        }
    }
}

class WebViewController: UIViewController, WKScriptMessageHandler {
    @Published var url: String = ""
    @Published var selectedText: String = ""
            
    private let script = """
        function __ViewTranslator_getSelectionAndSendMessage()
        {
            var txt = document.getSelection().toString() ;
            webkit.messageHandlers.callbackHandler.postMessage(txt);
        }
        document.onselectionchange = __ViewTranslator_getSelectionAndSendMessage ;
    """
    lazy var webView: WKWebView = {
        let contentController = WKUserContentController();
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.add( self, name: "callbackHandler")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        return WKWebView(frame: self.view.frame, configuration: config)
    }()

    init(store: Store) {
        super.init(nibName: nil, bundle: nil)
        
        _ = $selectedText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if text != "" {
                    store.selectedText = text
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
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            if let text = message.body as? String {
                selectedText = text
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
