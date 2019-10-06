//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct Translator : ViewRepresentable {
    @Binding var text: URLQueryItem
    private let defaultUrl = "https://translate.google.com?sl=auto&tl=ru"
        
    static var pageView: PageWebView?
    private var view: PageWebView {
        if let view = Self.pageView { return view }
        
        let view = PageWebView(defaultUrl: defaultUrl)
        Self.pageView = view
        
        return view
    }
    
    func makeView(context: Context) -> PageWebView  {
        print("Translator_makeView")
        return view
    }
      
    func updateView(_ view: PageWebView, context: Context) {
        print("Translator_updateView")
        let lastUrl = view.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultUrl
        
        guard var urlComponent = URLComponents(string: url) else { return }
        guard let queryItems = urlComponent.queryItems else { return }

        let text = queryItems.first(where: { $0.name == "text" })?.value ?? ""
        
        if text == self.text.value { return }

        let sl = queryItems.first(where: { $0.name == "sl" })?.value
        let tl = queryItems.first(where: { $0.name == "tl" })?.value

        urlComponent.queryItems = [
            .init(name: "sl", value: sl),
            .init(name: "tl", value: tl),
            self.text
        ]
        
        if let url = urlComponent.url {
            print("Translator_updateView_reload")
            view.load(URLRequest(url: url))
        }
    }
}




