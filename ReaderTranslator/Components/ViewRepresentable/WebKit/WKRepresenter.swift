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

    static var pageView: WKPageView { views[WebStore.shared.currentTab]! }
    static var hasSentTranslateAction = false

    @ObservedObject private var store = Store.shared
    @ObservedObject var webStore = WebStore.shared

    private static var views = [Int: WKPageView]()

    static var currentWebView: WKPageView? {
        Self.views[WebStore.shared.currentTab]
    }

    func makeCoordinator() -> WKCoordinator {
        WKCoordinator(self, currentView: .web)
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.views[webStore.currentTab] { return view }
        let view = WKPageView()
        Self.views[webStore.currentTab] = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        Task {
            await MainActor.run {
                webStore.canGoBack = view.canGoBack
            }
        }

        return view
    }

    func updateView(_ view: WKPageView, context _: Context) {
        #if os(macOS)
//        TODO: view.scrollView.zoomScale = store.zoom
//        view.setNeedsDisplay(view.bounds)
        #else
//            view.setZoom(zoomLevel: store.zoom)
        #endif
        if view.newUrl != lastWebPage { view.newUrl = lastWebPage }
    }

    func webView(_ webView: WKPageView, didFinish _: WKNavigation!) {
        if let url = webView.url?.absoluteString { webStore.lastWebPage = url.decodeUrl }
        webStore.canGoBack = webView.canGoBack
    }

    func goBack(_ webView: WKPageView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = webView.url?.absoluteString { webView.newUrl = url }
            self.webStore.canGoBack = webView.canGoBack
        }
    }
}
