//
//  WKWebView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/11/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import WebKit

extension WKWebView {
    func historyBack() {
        evaluateJavaScript("window.history.back();")
    }

    func historyForward() {
        evaluateJavaScript("window.history.forward();")
    }
}
