//
//  WebView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

#if os(macOS)

struct WebView: NSViewRepresentable {
    @Binding var lastWebPage: String

    static var pageView: PageWebView { views[Store.shared.currentTab]! }
    
    @ObservedObject private var store = Store.shared
    static private var views = [Int: PageWebView]()
    private var view: PageWebView {
        if let view = WebView.views[store.currentTab] { return view }
        let view = PageWebView()
        
        WebView.views[self.store.currentTab] = view
        store.canGoBack = view.canGoBack

        return view
    }
    
    func makeNSView(context: Context) -> PageWebView { view }

    func updateNSView(_ view: PageWebView, context: Context) {
        #if os(macOS)
        //TODO: view.scrollView.zoomScale = store.zoom
        view.setNeedsDisplay(view.bounds)
        #else
        view.scrollView.zoomScale = store.zoom
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }
}
#else
struct WebView: UIViewRepresentable {
    @Binding var lastWebPage: String

    @ObservedObject private var store = Store.shared
    static private var views = [Int: PageWebView]()
    private var view: PageWebView { WebView.views[store.currentTab] ?? PageWebView() }

    static var pageView: PageWebView { views[Store.shared.currentTab]! }
    
    func makeUIView(context: Context) -> PageWebView {
        WebView.views[self.store.currentTab] = view
        store.canGoBack = view.canGoBack
        
        return view
    }

    func updateUIView(_ uiView: PageWebView, context: Context) {
        uiView.setZoom(zoomLevel: store.zoom)
        if uiView.newUrl != lastWebPage { uiView.newUrl = lastWebPage }
    }
}
#endif


