//
//  Store.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 30/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

class Store: ObservableObject {
    static var shared = Store()

    @Published(wrappedValue: nil, key: "lastAudio") var lastAudio: URL?
    @Published(key: "audioRate") var audioRate: Float = 1
}
