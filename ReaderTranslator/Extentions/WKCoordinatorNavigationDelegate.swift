//
//  WKNavigationDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import WebKit

protocol WKCoordinatorNavigationDelegate: AnyObject {
    @MainActor func goBack(_ webView: WKWebView)
}

extension WKCoordinatorNavigationDelegate {
    @MainActor func goBack(_: WKWebView) {}
}
