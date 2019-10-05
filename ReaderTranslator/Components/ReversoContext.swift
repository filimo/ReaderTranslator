//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReversoContext : ViewRepresentable {
    @Binding var text: String
    
    static private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        
        return WKWebView(frame: .zero, configuration: config)
    }()
    
    
    func makeView(context: Context) -> WKWebView  { ReversoContext.webView }
      
    func updateView(_ view: WKWebView, context: Context) {
        let host = "https://context.reverso.net/translation/english-russian/"
        let search = text.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(host)\(search)"
        
        if(view.url?.absoluteString == urlString) { return }
        
        if let url = URL(string: urlString) {
            view.load(URLRequest(url: url))
        }
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




