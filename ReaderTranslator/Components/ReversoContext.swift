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
    
    static var pageView: PageWebView?
    private var view: PageWebView {
        if let view = Self.pageView { return view }
        
        let view = PageWebView()
        Self.pageView = view
        
        return view
    }
    
    func makeView(context: Context) -> PageWebView  {
        print("ReversoContext_makeView")
        return view
    }
      
    func updateView(_ view: PageWebView, context: Context) {
        print("ReversoContext_updateView")
        let host = "https://context.reverso.net/translation/english-russian/"
        let search = text.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(host)\(search)"
        
        if view.url?.absoluteString == urlString { return }
        
        if let url = URL(string: urlString) {
            print("ReversoContext_updateView_reload")
            view.load(URLRequest(url: url))
        }
    }
}




