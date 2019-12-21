//
//  AudioStore.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 21/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class WebStore: ObservableObject {
    private init() {
        ({ currentTab = currentTab })() // call didSet
    }
    static var shared = WebStore()

    @Published(key: "currentTab") var currentTab = 0 {
        didSet { lastWebPage = savedLastWebPage[self.currentTab] }
    }

    @Published var canGoBack = false
    @UserDefault(key: "lastWebPage")
    private var savedLastWebPage = ["https://google.com", "", ""]
    @Published
    var lastWebPage = "" { willSet { savedLastWebPage[self.currentTab] = newValue } }
}
