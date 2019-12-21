//
//  Store.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

final class Store: ObservableObject {
    private init() {}
    static var shared = Store()

    var lastWebPage = ""

    @Published var hideNavBar = true
    @Published(key: "bookmarks") var bookmarks: BookmarksStore.Bookmarks = []
}
