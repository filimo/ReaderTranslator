//
//  Store.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
    static var shared = Store()

    @Published var hideNavBar = true

    var lastWebPage = ""

    @Published(key: "bookmarks") var bookmarks: BookmarksStore.Bookmarks = []
}
