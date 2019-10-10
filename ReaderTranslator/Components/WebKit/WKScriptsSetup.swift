//
//  ViewRepresentableJavaScriptDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import WebKit

private let script = """
    document.onselectionchange = function() {
        var txt = document.getSelection().toString()
        
        webkit.messageHandlers.onSelectionChange.postMessage(txt)
    }
    window.oncontextmenu = function() {
        var txt = document.getSelection().toString()
        
        webkit.messageHandlers.onContextMenu.postMessage("txt")
    }
    document.body.onload = function() {
        webkit.messageHandlers.onBodyLoaded.postMessage("txt")
    }
    document.body.onkeydown = function(event) {
        webkit.messageHandlers.onKeyDown.postMessage(event.code)
    }
"""

protocol WKScriptsSetup {
    static var hasSentTranslateAction: Bool { get set }
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!)
    func goBack(_ webView: WKPageView)
}

extension WKScriptsSetup {
    func sentTranslateAction() {
        Self.hasSentTranslateAction = true
    }

    func setupScripts(view: WKPageView, coordinator: WKCoordinator) {
        let userContentController = view.configuration.userContentController

        userContentController.add(coordinator, name: "onSelectionChange")
        userContentController.add(coordinator, name: "onContextMenu")
        userContentController.add(coordinator, name: "onBodyLoaded")
        userContentController.add(coordinator, name: "onKeyDown")
        
        #if os(macOS)
        view.allowsMagnification = true
        #endif
        view.navigationDelegate = coordinator
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(userScript)
    }
    
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!) {}
    func goBack(_ webView: WKPageView) {}
}

