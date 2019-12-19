//
//  BookmarksView_List.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView_List: View {
    @ObservedObject var store = Store.shared

    var columnts: Int
    var width: CGFloat
    @Binding var filter: String
    var debug = false

    private var bookmarkItems: [BookmarksStore.Bookmarks] {
        if case let .bookmarks(text) = store.translateAction {
            self.store.translateAction.next()
            store.bookmarks.longmanSelectedBookmark = text
        }

        var bookmarks = debug ? [.init(text: "test")] : store.bookmarks.items
        let filter = self.filter.trimmingCharacters(in: .whitespaces)

        if !filter.isEmpty {
            bookmarks = bookmarks.filter { $0.text.contains(filter) }
        }

        return bookmarks
            .filter(counter: store.bookmarks.filterCounter)
            .chunked(into: columnts)
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(bookmarkItems, id: \.self) { chunk in
                    BookmarksView_List_Row(items: chunk, width: self.width)
                }
            }
        }
    }
}

struct BookmarksView_List_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_List(columnts: 3, width: 100, filter: .constant(""), debug: true)
    }
}
