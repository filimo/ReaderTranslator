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
        webkit.messageHandlers.onKeyPress.postMessage(event.code)
    }
"""

protocol WKScriptsSetup {}

extension WKScriptsSetup {
    func setupScripts(userContentController: WKUserContentController, coordinator: WKScriptMessageHandler) {
//        let userContentController = view.configuration.userContentController

        userContentController.add(coordinator, name: "onSelectionChange")
        userContentController.add(coordinator, name: "onContextMenu")
        userContentController.add(coordinator, name: "onBodyLoaded")
        userContentController.add(coordinator, name: "onKeyPress")
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        userContentController.addUserScript(userScript)
    }
}

