//
//  WebView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct WebView: ViewRepresentable {
    @Binding var lastWebPage: String

    static var pageView: PageWebView { views[Store.shared.currentTab]! }
    
    @ObservedObject private var store = Store.shared
    static private var views = [Int: PageWebView]()
    private var view: PageWebView {
        if let view = Self.views[store.currentTab] { return view }
        let view = PageWebView()
        
        Self.views[self.store.currentTab] = view
        store.canGoBack = view.canGoBack

        return view
    }
    
    func makeView(context: Context) -> PageWebView {
        print("WebView_makeNSView")
        return view
    }

    func updateView(_ view: PageWebView, context: Context) {
        print("WebView_updateNSView")
        #if os(macOS)
//        TODO: view.scrollView.zoomScale = store.zoom
//        view.setNeedsDisplay(view.bounds)
        #else
        view.setZoom(zoomLevel: store.zoom)
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }
}


