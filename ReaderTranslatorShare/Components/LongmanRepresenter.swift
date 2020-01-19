//
//  WKRepresenter.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 1/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

private var view: WKPageView?

struct LongmanRepresenter: UIViewRepresentable, WKScriptsSetup {
    var phrase: String
    static private var phrase: String = ""
    private let defaultURL = "https://www.ldoceonline.com/dictionary/"
    static var pageView = WKPageView()

    func makeUIView(context _: Context) -> WKPageView {
        Self.pageView
    }

    func updateUIView(_ pageView: WKPageView, context _: Context) {
        if Self.phrase == phrase { return }
        Self.phrase = phrase

        let search = phrase.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadWithRuleList(urlString: urlString, view: pageView, file: "longman")
        }
    }
}
