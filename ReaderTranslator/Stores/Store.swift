//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Combine

enum ViewMode: String {
    case pdf
    case web
}

class Store: ObservableObject {
    static var shared = Store()
    
    @Published var selectedText = ""
    @Published var currentPage = "1"
    @Published var pageCount = 0
    
    @Published(key: "viewMode") var viewMode = ViewMode.pdf

    @Published(key: "voiceLanguage") var voiceLanguage = "Select language"
    @Published(key: "voiceName")  var voiceName = "Select voice"

    @Published(key: "lastWebPage") var lastWebPage = "https://wwww.google.com"
    
    @Published(key: "lastPage") var lastPage = "1"
    
    @Published(key: "isVoiceEnabled") var isVoiceEnabled = true
    
    @Published(key: "zoom") var zoom: CGFloat = 1

    private init() {}
}
