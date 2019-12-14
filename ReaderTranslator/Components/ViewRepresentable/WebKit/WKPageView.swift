//
//  PageWebView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/4/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Combine
import SwiftUI
import WebKit

class WKPageView: WKWebView {
    @ObservedObject private var store = APStore.shared
    private var zoomLevel: CGFloat = 1

    @Published var newUrl: String = ""

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        config.userContentController = contentController
        config.websiteDataStore = .nonPersistent()

        super.init(frame: .zero, configuration: config)

        $newUrl
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { url in
                if self.url?.absoluteString.decodeUrl != url {
                    self.evaluateJavaScript("document.documentElement.innerHTML = ''")
                    if let url = URL(string: url.encodeUrl) {
                        self.load(URLRequest(url: url))
                    } else {
                        self.evaluateJavaScript("window.location = 'about:blank'")
                    }
                }
            }
            .store(in: &cancellableSet)
    }

    func load(urlString: String) {
        newUrl = urlString
    }

    deinit {
        cancellableSet.cancelAndRemoveAll()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func goBack() {
        super.goBack()
        (self.navigationDelegate as? WKCoordinatorNavigationDelegate)?.goBack(self)
    }
}

#if os(macOS)
extension WKPageView {
//    override func layout() {
//        super.layout()
//        self.frame.size = CGSize(width: frame.width * (1/zoomLevel), height: frame.height * (1/zoomLevel))
//        self.layer?.transform = CATransform3DMakeScale(zoomLevel, zoomLevel, 1)
//    }
//
    func setZoom(zoomLevel: CGFloat) {
//        self.zoomLevel = zoomLevel
//        self.needsLayout = true
    }
}
#else
extension WKPageView {
    func setZoom(zoomLevel: CGFloat) {
        self.scrollView.setZoomScale(zoomLevel, animated: true)
        self.scrollView.minimumZoomScale = zoomLevel
//TODO: I don't know to need call it        self.setNeedsDisplay(self.bounds)
    }
}
#endif
