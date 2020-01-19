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
    var sentence: String
    static var sentence: String = ""
    static var pageView = WKPageView()

    private let defaultURL = "https://translate.google.com?op=translate&sl=auto&tl=ru"

    func makeUIView(context _: Context) -> WKPageView {
        Self.pageView
    }

    func updateUIView(_ pageView: WKPageView, context _: Context) {
        if Self.sentence == sentence { return }
        Self.sentence = sentence
        guard let urlRequest = urlRequest(pageView: pageView) else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            pageView.load(urlRequest)
        }
    }

    private func urlRequest(pageView: WKPageView) -> URLRequest? {
        let (slValue, tlValue) = getParams(url: pageView.url)
        guard var urlComponent = URLComponents(string: defaultURL) else { return nil }
        urlComponent.queryItems = [
            .init(name: "op", value: "translate"),
            .init(name: "sl", value: slValue),
            .init(name: "tl", value: tlValue),
            .init(name: "text", value: sentence)
        ]

        guard let url = urlComponent.url else { return nil }

        return URLRequest(url: url)
    }

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
