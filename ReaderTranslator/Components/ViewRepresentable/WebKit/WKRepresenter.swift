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

    static var coorinator: Coordinator?
    static var pageView: WKPageView { views[WebStore.shared.currentTab]! }
    static var hasSentTranslateAction = false

    @ObservedObject private var store = Store.shared
    @ObservedObject var webStore = WebStore.shared

    private static var views = [Int: WKPageView]()

    class Coordinator: WKCoordinator {
        @Published var selectedText = ""

        override init(_ parent: WKScriptsSetup) {
            super.init(parent)
            print("\(theClassName)_Coordinator_init")

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if text != "" { self.store.translateAction.addAll(text: text) }
                }
                .store(in: &cancellableSet)
        }
    }

    func makeCoordinator() -> Coordinator {
        makeCoordinator(coordinator: Coordinator(self))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.views[webStore.currentTab] { return view }
        let view = WKPageView()
        Self.views[self.webStore.currentTab] = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)
        webStore.canGoBack = view.canGoBack

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

extension WKRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }

        switch event.name {
        case "selectionchange":
            selectedText = event.extra?.selectedText ?? ""
        case "keydown":
            if event.extra?.keyCode == 18 { // Alt
                SpeechSynthesizer.speak(text: selectedText, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}
