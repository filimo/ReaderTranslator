//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#else
typealias ViewRepresentable = UIViewRepresentable
#endif


struct TranslatorView : ViewRepresentable {
    @Binding var text: URLQueryItem
    static private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        
        return WKWebView(frame: .zero, configuration: config)
    }()
      
    func makeView(context: Context) -> WKWebView  { TranslatorView.webView }
      
    func updateView(_ view: WKWebView, context: Context) {
        let lastUrl = view.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? "https://translate.google.com?sl=auto&tl=ru"
        
        guard var urlComponent = URLComponents(string: url) else { return }
        guard let queryItems = urlComponent.queryItems else { return }

        let text = queryItems.first(where: { $0.name == "text" })?.value
        
        if text == self.text.value { return }

        let sl = queryItems.first(where: { $0.name == "sl" })?.value
        let tl = queryItems.first(where: { $0.name == "tl" })?.value

        urlComponent.queryItems = [
            .init(name: "sl", value: sl),
            .init(name: "tl", value: tl),
            self.text
        ]
        
        view.load(URLRequest(url: urlComponent.url!))
    }
    
    #if os(macOS)
    func makeNSView(context: Context) -> WKWebView  {
        makeView(context: context)
    }
    func updateNSView(_ view: WKWebView, context: Context) {
        updateView(view, context: context)
    }
    #else
    func makeUIView(context: Context) -> WKWebView  {
        makeView(context: context)
    }
    func updateUIView(_ view: WKWebView, context: Context) {
        updateView(view, context: context)
    }
    #endif
}




