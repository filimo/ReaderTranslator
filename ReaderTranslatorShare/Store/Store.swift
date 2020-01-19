//
//  Store.swift
//  ReaderTranslatorShare
//
//  Created by Viktor Kushnerov on 19/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI


enum ViewMode {
    case gTranslator
    case longman
}

class Store: ObservableObject {
    private init() {}
    static let shared = Store()
    @Published var sentence = ""
    @Published var viewMode = ViewMode.gTranslator
}
