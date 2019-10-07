//
//  WebViewRepresentable.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct WKRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var lastWebPage: String

    static var pageView: WKPage { views[Store.shared.currentTab]! }
    
    @ObservedObject private var store = Store.shared
    static private var views = [Int: WKPage]()

    class Coordinator: WKCoordinator {
        override init(_ parent: WKScriptsSetup) {
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
    
    func makeView(context: Context) -> WKPage {
        print("WebView_makeNSView")
        
        if let view = Self.views[store.currentTab] { return view }
        let view = WKPage(defaultUrl: "")
        
        #if os(macOS)
        view.allowsMagnification = true
        #endif
        view.navigationDelegate = context.coordinator
        
        setupScripts(
            userContentController: view.configuration.userContentController,
            coordinator: context.coordinator)
        
        Self.views[self.store.currentTab] = view
        store.canGoBack = view.canGoBack

        return view
    }

    func updateView(_ view: WKPage, context: Context) {
        print("WebView_updateNSView")
        #if os(macOS)
//        TODO: view.scrollView.zoomScale = store.zoom
//        view.setNeedsDisplay(view.bounds)
        #else
        view.setZoom(zoomLevel: store.zoom)
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }
}




