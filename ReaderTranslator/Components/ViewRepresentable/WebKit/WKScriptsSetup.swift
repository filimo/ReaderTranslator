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
    func setupScriptCoordinator<T: WKCoordinator>(view: WKPageView, coordinator: T) where T: WKScriptMessageHandler {
        let userContentController = view.configuration.userContentController
        guard let scriptUrl = Bundle.main.url(forResource: "reader-translator", withExtension: "js") else { return }

        do {
            let script = try String(contentsOf: scriptUrl)

            userContentController.add(coordinator, name: "send")

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
        } catch {
            print(error.localizedDescription)
        }
    }

    func setupScript(view: WKPageView, file name: String) {
        let userContentController = view.configuration.userContentController
        guard let scriptUrl = Bundle.main.url(forResource: name, withExtension: "js") else { return }

        do {
            let script = try String(contentsOf: scriptUrl)

            let userScript = WKUserScript(
                source: script,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )
            userContentController.addUserScript(userScript)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadWithRuleList(urlString: String, view: WKPageView, file name: String) {
        guard let jsonURL = Bundle.main.url(forResource: name, withExtension: "json") else { return }

        do {
            let json = try String(contentsOf: jsonURL)

            WKContentRuleListStore.default()?.compileContentRuleList(
                forIdentifier: "ContentBlockingRules",
                encodedContentRuleList: json,
                completionHandler: { contentRuleList, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let contentRuleList = contentRuleList else { return }

                    view.configuration.userContentController.add(contentRuleList)

                    view.load(urlString: urlString)
                }
            )

        } catch {
            print(error.localizedDescription)
        }
    }

    func webView(_: WKPageView, didFinish _: WKNavigation!) {}
    func goBack(_: WKPageView) {}
}
