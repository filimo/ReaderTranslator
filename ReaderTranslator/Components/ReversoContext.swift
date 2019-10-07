//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReversoContext : ViewRepresentable, ScriptViewRepresenterDelegate {
    @Binding var text: String
    private let host = "https://context.reverso.net/translation/english-russian/"

    static var pageView: PageWebView?
    
    class Coordinator: ScriptViewRepresenterCoordinator {
        override init(_ parent: ScriptViewRepresenterDelegate) {
            super.init(parent)

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if text != "" { self.store.selectedText = text }
                }
                .store(in: &cancellableSet)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> PageWebView  {
        print("ReversoContext_makeView")
        if let view = Self.pageView { return view }
        
        let view = PageWebView(defaultUrl: host)
        Self.pageView = view
        
        addJavaScriptEvents(
            userContentController: view.configuration.userContentController,
            coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: PageWebView, context: Context) {
        print("ReversoContext_updateView")
        let search = text.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(host)\(search)"
        
        if view.url?.absoluteString == urlString { return }
        
        if let url = URL(string: urlString) {
            print("ReversoContext_updateView_reload")
            view.load(URLRequest(url: url))
        }
    }
}




