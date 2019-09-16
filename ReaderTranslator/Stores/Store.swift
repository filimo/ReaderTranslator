//
//  Store.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/14/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation
import Speech

enum ViewMode: String {
    case pdf
    case web
}

class Store: ObservableObject {
    @Published var selectedText = ""
    @Published var currentPage = "1"
    @Published var pageCount = 0
    @Published var mode = ViewMode.pdf
    @Published var voiceName = ""
    @Published var voiceLanguage = ""
}
