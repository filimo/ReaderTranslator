//
//  Bookmark.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct Bookmark: Codable, Hashable {
    var counter: Int = 0
    let text: String
    var changed: Date
}

typealias Bookmarks = [Bookmark]

extension Array where Element == Bookmark {
    var sorted: [Element] {
        self.sorted { $0.text < $1.text }
    }

    func contains(text: String) -> Bool {
        self.first { $0.text == text } != nil
    }

    func firstIndex(text: String) -> Int? {
        self.firstIndex { $0.text == text }
    }

    func first(text: String) -> Element? {
        self.first { $0.text == text }
    }

    mutating func remove(text: String) {
        guard let index = self.firstIndex(text: text) else { return }
        self.remove(at: index)
    }

    mutating func append(_ text: String) {
        self.append(Bookmark(text: text, changed: Date()))
    }

    mutating func append(items: [Substring]) {
        items.forEach { self.append(String($0)) }
    }

    func joined(separator: String) -> String {
        self.map { $0.text }.joined(separator: separator)
    }

    func chunked(into: Int) -> [Element] {
        self
        .sorted { $0.text.lowercased() < $1.text.lowercased() }
        .chunked(into: into)
    }

    func filter(counter: Int?) -> [Element] {
        guard let counter = counter else { return self }
        return self.filter { $0.counter == counter }
    }

    mutating func increase(bookmark: Element) {
        guard let index = self.firstIndex(of: bookmark) else { return }
        let counter = self[index].counter

        if counter > 4 {
            self[index].counter = 0
        } else {
            self[index].counter += 1
        }
        self[index].changed = Date()
    }

    mutating func clearAllCounters() {
        for index in self.indices {
            self[index].counter = 0
            self[index].changed = Date()
        }
    }
}
