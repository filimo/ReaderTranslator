//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct GTranslatorRepresenter: UIViewRepresentable {
    static var sentence: String = ""
    var sentence: String

    static var pageView = WKPageView()

    @ObservedObject private var store = Store.shared
    private let defaultURL = "https://translate.google.com?op=translate&sl=auto&tl=ru"

    func makeUIView(context _: Context) -> WKPageView {
        if Self.sentence == sentence { return Self.pageView }
        Self.sentence = sentence

        let (slValue, tlValue) = getParams(url: Self.pageView.url)

        guard var urlComponent = URLComponents(string: defaultURL) else { return Self.pageView }
        urlComponent.queryItems = [
            .init(name: "op", value: "translate"),
            .init(name: "sl", value: slValue),
            .init(name: "tl", value: tlValue),
            .init(name: "text", value: sentence)
        ]

        if let url = urlComponent.url {
            print("\(theClassName)_updateView_reload", url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Self.pageView.load(URLRequest(url: url))
            }
        }
        Self.pageView.load(urlString: defaultURL)
        return Self.pageView
    }

    func updateUIView(_: WKPageView, context _: Context) {}

    private func getParams(url: URL?) -> (String?, String?) {
        let lastUrl = url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultURL

        guard let urlComponent = URLComponents(string: url) else { return (nil, nil) }
        let queryItems = urlComponent.queryItems

        let slValue = queryItems?.last(where: { $0.name == "sl" })?.value
        let tlValue = queryItems?.last(where: { $0.name == "tl" })?.value

        return (slValue, tlValue)
    }
}
