//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum ViewMode: String {
    case pdf
    case web
}

class Store: ObservableObject {
    static var shared = Store()
    
    @Published var selectedText = ""
    @Published var currentPage = "1"
    @Published var pageCount = 0

    @Published(key: "currentTab") var currentTab = 0 {
        didSet {
            self.lastWebPage = self.savedLastWebPage[self.currentTab]
        }
    }
    
    @Published(key: "viewMode") var viewMode = ViewMode.pdf

    @Published(key: "voiceLanguage") var voiceLanguage = "Select language"
    @Published(key: "voiceName")  var voiceName = "Select voice"
    @Published(key: "isVoiceEnabled") var isVoiceEnabled = true
    @Published(key: "voiceRate")  var voiceRate = "0.4"

    @UserDefault(key: "lastWebPage")
    private var savedLastWebPage = ["https://wwww.google.com", "", ""]
    @Published
    var lastWebPage = "" {
        willSet {
            self.savedLastWebPage[self.currentTab] = newValue
        }
    }
    
    @Published(key: "lastPage") var lastPage = "1"

    @Published(key: "zoom") var zoom: CGFloat = 1


    private init() {
        self.lastWebPage = self.savedLastWebPage[self.currentTab]
    }
}
