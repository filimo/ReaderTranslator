//
//  WKRepresenter.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 1/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct WKWebRepresenter: UIViewRepresentable, WKScriptsSetup {
    func makeUIView(context: Context) -> WKPageView {
        let view = WKPageView()
        loadWithRuleList(urlString: "https://www.ldoceonline.com", view: view, file: "longman")
        return view
    }

    func updateUIView(_ view: WKPageView, context: Context) {
    }
}
