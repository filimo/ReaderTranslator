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
    let created: Date
    var changed: Date
}

typealias Bookmarks = [Bookmark]

extension Array where Element == Bookmark {
    var sorted: [Element] {
        self.sorted { $0.text < $1.text }
    }

    func contains(text: String) -> Bool {
        first { $0.text == text } != nil
    }

    func firstIndex(text: String) -> Int? {
        firstIndex { $0.text == text }
    }

    func first(text: String) -> Element? {
        first { $0.text == text }
    }

    mutating func remove(text: String) {
        guard let index = self.firstIndex(text: text) else { return }
        remove(at: index)
    }

    mutating func append(_ text: String) {
        append(Bookmark(text: text, created: Date(), changed: Date()))
    }

    mutating func append(items: [Substring]) {
        items.forEach { self.append(String($0)) }
    }

    func joined(separator: String) -> String {
        map { $0.text }.joined(separator: separator)
    }

    func chunked(into: Int) -> [Element] {
        sorted { $0.text.lowercased() < $1.text.lowercased() }
            .chunked(into: into)
    }

    func filter(counter: Int) -> [Element] {
        if counter == -1 { return self }
        return filter { $0.counter == counter }
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
        for index in indices {
            self[index].counter = 0
            self[index].changed = Date()
        }
    }

    var json: String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Bookmarks_\(#function)", error)
        }
        return "[]"
    }

    mutating func save(data: Data?) {
        guard let content = data else { return }
        if let jsonString = String(data: content, encoding: .unicode) {
            self.save(jsonString: jsonString)
        }
    }

    mutating func save(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else { return }
        do {
            self = try JSONDecoder().decode(Bookmarks.self, from: jsonData)
        } catch {
            print("Bookmarks_\(#function)", error)
        }
    }
}
