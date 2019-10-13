//
//  ViewRepresentableJavaScriptDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/7/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import WebKit

protocol WKScriptsSetup {
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!)
    func goBack(_ webView: WKPageView)
}

extension WKScriptsSetup {
    func setupScripts<T: WKCoordinator>(view: WKPageView, coordinator: T) where T: WKScriptMessageHandler {
        let userContentController = view.configuration.userContentController
        guard let scriptUrl = Bundle.main.url(forResource: "reader-translator", withExtension: "js") else { return }
        
        do {
            let script = try String(contentsOf: scriptUrl)

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
        }catch{
            print(error.localizedDescription)
        }
    }
        
    func webView(_ webView: WKPageView, didFinish navigation: WKNavigation!) {}
    func goBack(_ webView: WKPageView) {}
}

