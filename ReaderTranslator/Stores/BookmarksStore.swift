//
//  Bookmark.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

final class BookmarksStore: ObservableObject {
    private init() {}
    static let shared = BookmarksStore()

    typealias Bookmarks = [Bookmark]

    @Published(key: "bookmarks") var items = Bookmarks()
    @Published var filterCounter = -1

    struct Log: Codable, Hashable {
        let created: Date
    }

    typealias Logs = [Log]

    struct Bookmark: Codable, Hashable {
        var counter: Int = 0
        let text: String
        let created: Date
        var changed: Date? // deprecated
        var logs: Logs = [] {
            didSet {
                 counter = logs.count
            }
        }

        var lastCreatedLog: Date {
            guard let log = (logs.max { $0.created < $1.created }) else { return Date() }
            return log.created
        }

        init(counter: Int = 0, text: String, created: Date = Date(), changed: Date? = nil) {
            self.counter = counter
            self.text = text
            self.created = created
            self.changed = changed
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let counter = try values.decode(Int.self, forKey: .counter)

            text = try values.decode(String.self, forKey: .text)
            created = try values.decode(Date.self, forKey: .created)

            do {
                changed = try values.decode(Date?.self, forKey: .changed)
            } catch {
            }

            if let changed = changed {
                if counter > 0 {
                    logs = (1...counter).map { _ in Log(created: changed) }
                }
                self.changed = nil
            } else {
                do {
                    logs = try values.decode(Logs.self, forKey: .logs)
                } catch {
                }
            }
            self.counter = logs.count
        }
    }
}

extension Array where Element == BookmarksStore.Bookmark {
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
        append(BookmarksStore.Bookmark(text: text, created: Date()))
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

    mutating func increase(bookmark: Element?) {
        guard let bookmark = bookmark else { return }
        guard let index = self.firstIndex(of: bookmark) else { return }

        self[index].logs.append(BookmarksStore.Log(created: Date()))
    }

    mutating func clearAllCounters() {
        for index in indices {
            self[index].logs = []
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

    func parse(jsonString: String) -> [Element] {
        guard let jsonData = jsonString.data(using: .utf8) else { return [] }
        do {
            return try JSONDecoder().decode(Self.self, from: jsonData)
        } catch {
            print("Bookmarks_\(#function)", error)
        }
        return []
    }

    func parse(data: Data?) -> [Element] {
        guard let content = data else { return [] }
        if let jsonString = String(data: content, encoding: .unicode) {
            return parse(jsonString: jsonString)
        }
        return []
    }

//    mutating func merge(data: Data?) {
//        let bookmarks = parse(data: data)
//        var newBookmarks: Bookmarks = []
//
//        // new item
//        // update item and increase counter
//        // remove item if deleted date > created item
//        // get new items from local bookmarks
//        for bookmark in bookmarks {
//            guard let index = self.firstIndex(text: bookmark.text) else {
//                append(bookmark)
//                continue
//            }
//
////            if self[index].changed < bookmark.changed {
////                self[index].changed = bookmark.changed
////                self[index].counter = bookmark.counter
////            } else if self[index].changed > bookmark.changed {
////                newBookmarks.append(self[index])
////            }
//
//            let diff = bookmarks.difference(from: self)
//        }
//    }

    mutating func save(data: Data?) {
        self = parse(data: data)
    }

    mutating func save(jsonString: String) {
        self = parse(jsonString: jsonString)
    }

    mutating func merge<C: Collection>(newElements: C) where C.Iterator.Element == Element {
        for element in newElements {
            if let index = self.firstIndex(text: element.text) {
                self[index].logs.merge(newElements: element.logs)
            } else {
                append(element)
            }
        }
    }
}
