//
//  WKRepresenter.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 1/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct WKWebRepresenter: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.ldoceonline.com") else { return }
        let script = """
            document.addEventListener("DOMContentLoaded", (event) => {
                document.getElementById('ad_topslot').remove()
                document.getElementsByClassName('dictionary_intro')[0].remove()
            })
        """
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        uiView.configuration.userContentController.addUserScript(userScript)

        uiView.load(URLRequest(url: url))
    }
}
