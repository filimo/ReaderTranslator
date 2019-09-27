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

struct WebView: UIViewRepresentable {
    @ObservedObject var store = Store.shared
    @Binding var lastWebPage: String
    static private var views = [Int: PageWebView]()
    
    static var pageView: PageWebView {
        get { views[Store.shared.currentTab]! }
    }
    
    func makeUIView(context: Context) -> PageWebView {
        let view = WebView.views[store.currentTab] ?? PageWebView()
        
        WebView.views[self.store.currentTab] = view
        
        store.canGoBack = view.canGoBack
        
        return view
    }

    func updateUIView(_ uiView: PageWebView, context: Context) {
        uiView.scrollView.zoomScale = store.zoom
        if uiView.newUrl != lastWebPage { uiView.newUrl = lastWebPage }
    }
}


//This hack to make PageWebView the first responder but the selection won't work
//extension UIView {
//    public override func becomeFirstResponder() -> Bool {
//        // Actual view is instance of private class UIWebBrowserView, its parent parent view is UIWebView
//        if self.superview?.superview is PageWebView {
//            print(1)
//            return false
//        } else {
//            return super.becomeFirstResponder()
//        }
//    }
//}

class PageWebView: WKWebView {
    @Published private var selectedText = ""
    @Published var newUrl = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
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
        document.body.onkeydown = function(event) {
            webkit.messageHandlers.onKeyPress.postMessage(event.code)
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
        contentController.add(self, name: "onKeyPress")


        $selectedText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { text in
                if text != "" {
                    self.store.selectedText = text
                }
            }
            .store(in: &cancellableSet)
        
        $newUrl
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { url in
                if self.url?.absoluteString.decodeUrl != url {
                    self.evaluateJavaScript("document.body.remove()")
                    if let url = URL(string: url.encodeUrl) {
                        self.load(URLRequest(url: url))
                    }
                }
            }
            .store(in: &cancellableSet)
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

extension PageWebView {
    override public var keyCommands: [UIKeyCommand]? {
        //Voice selected text with any key since performCommand isn't fired because PageWebView isn't the first responder.
        SpeechSynthesizer.speech()
        return [.init(input: "1", modifierFlags: .command, action: #selector(performCommand))]
    }

    @objc func performCommand(sender: UIKeyCommand) {
        print(sender)
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
        case "onKeyPress":
            if let code = message.body as? String {
                if code == "Space" { SpeechSynthesizer.speech() }
            }
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
        if let url = self.url?.absoluteString { store.lastWebPage = url.decodeUrl }
        store.canGoBack = canGoBack
        self.scrollView.minimumZoomScale = self.store.zoom
        self.scrollView.setZoomScale(self.store.zoom, animated: true)
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
    
    override func goBack() -> WKNavigation? {
        let nav = super.goBack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = self.url?.absoluteString { self.newUrl = url }
            self.store.canGoBack = self.canGoBack
        }
        return nav
    }
    
}

