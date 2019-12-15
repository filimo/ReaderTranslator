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
    @ObservedObject var store = Store.shared
    private let defaultURL = "https://www.ldoceonline.com/dictionary/"

    func makeUIView(context _: Context) -> WKPageView {
        if view == nil { view = WKPageView() }
        guard let view = view else { return WKPageView() }

        let search = store.longmanSelectedBookmark.replacingOccurrences(of: " ", with: "-")
        let urlString = "\(defaultURL)\(search)"

        loadWithRuleList(urlString: urlString, view: view, file: "longman")

        return view
    }

    func updateUIView(_: WKPageView, context _: Context) {}
}
