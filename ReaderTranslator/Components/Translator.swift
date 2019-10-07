//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct Translator : ViewRepresentable, ScriptViewRepresenterDelegate {
    @Binding var text: String
    private let defaultUrl = "https://translate.google.com?sl=auto&tl=ru"
        
    static var pageView: PageWebView?

    class Coordinator: ScriptViewRepresenterCoordinator {
        override init(_ parent: ScriptViewRepresenterDelegate) {
            super.init(parent)

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if text != "" { self.store.selectedTextInTranslator = text }
                }
                .store(in: &cancellableSet)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> PageWebView  {
        print("Translator_makeView")
        if let view = Self.pageView { return view }
        
        let view = PageWebView(defaultUrl: defaultUrl)
        Self.pageView = view
        
        addJavaScriptEvents(
            userContentController: view.configuration.userContentController,
            coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: PageWebView, context: Context) {
        print("Translator_updateView")
        let lastUrl = view.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultUrl
        
        guard var urlComponent = URLComponents(string: url) else { return }
        print(urlComponent)
        guard let queryItems = urlComponent.queryItems else { return }

        let text = queryItems.first(where: { $0.name == "text" })?.value ?? ""
        print("text:", text, "self.text:", self.text)
        if text == self.text { return }

        let sl = queryItems.first(where: { $0.name == "sl" })?.value
        let tl = queryItems.first(where: { $0.name == "tl" })?.value

        urlComponent.queryItems = [
            .init(name: "sl", value: sl),
            .init(name: "tl", value: tl),
            .init(name: "text", value: self.text)
        ]
        
        if let url = urlComponent.url {
            print("Translator_updateView_reload")
            view.load(URLRequest(url: url))
        }
    }
}




