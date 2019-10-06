//
//  PageWebView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/4/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import Combine
import WebKit

class PageWebView: WKWebView {
    private var store = Store.shared
    private var zoomLevel: CGFloat = 1
        
    @Published var newUrl: String

    private var cancellableSet: Set<AnyCancellable> = []

    init(defaultUrl: String) {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        config.userContentController = contentController
        config.websiteDataStore = .nonPersistent()

        self.newUrl = defaultUrl
        super.init(frame: .zero, configuration: config)
    
        if let url = URL(string: defaultUrl) {
            self.load(URLRequest(url: url))
        }
        
        $newUrl
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { url in
                if self.url?.absoluteString.decodeUrl != url {
                    self.evaluateJavaScript("document.documentElement.innerHTML = ''")
                    if let url = URL(string: url.encodeUrl) {
                        self.load(URLRequest(url: url))
                    }else{
                        self.evaluateJavaScript("window.location = 'about:blank'")
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func goBack() -> WKNavigation? {
        let nav = super.goBack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let url = self.url?.absoluteString { self.newUrl = url }
            self.store.canGoBack = self.canGoBack
        }
        return nav
    }
}


#if os(macOS)
extension PageWebView {
    @discardableResult
    static func open(_ url: URL) -> Bool {
        NSWorkspace.shared.open(url)
    }

    //TODO: implement keyCommands and performCommand
}
#else
extension PageWebView {
    static func open(_ url: URL) -> () {
       UIApplication.shared.open(url)
    }

    override public var keyCommands: [UIKeyCommand]? {
        //Voice selected text with any key since performCommand isn't fired because PageWebView isn't the first responder.
        SpeechSynthesizer.speak(stopSpeaking: true, isVoiceEnabled: true)
        return [.init(input: "1", modifierFlags: .command, action: #selector(performCommand))]
    }

    @objc func performCommand(sender: UIKeyCommand) {
        print(sender)
    }
}
#endif

#if os(macOS)
extension PageWebView {
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
extension PageWebView {
    func setZoom(zoomLevel: CGFloat) {
        self.scrollView.setZoomScale(zoomLevel, animated: true)
        self.scrollView.minimumZoomScale = zoomLevel
//TODO: I don't know to need call it        self.setNeedsDisplay(self.bounds)
    }
}
#endif
