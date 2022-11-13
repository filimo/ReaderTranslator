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
    @ObservedObject var longmanStore = LongmanStore.shared
    @ObservedObject var bookmarksStore = BookmarksStore.shared

    var columnts: Int
    var width: CGFloat
    @Binding var filter: String
    var debug = false

    private var bookmarkItems: [BookmarksStore.Bookmarks] {
        if case let .bookmarks(text) = store.translateAction {
            self.store.translateAction.next()
            Task {
                await MainActor.run {
                    longmanStore.word = text
                }
            }
        }

        var bookmarks = debug ? [.init(text: "test")] : bookmarksStore.items
        let filter = self.filter.trimmingCharacters(in: .whitespaces)

        if !filter.isEmpty {
            bookmarks = bookmarks.filter { $0.text.contains(filter) }
        }

        return bookmarks
            .filter(counter: bookmarksStore.filterCounter)
            .chunked(into: columnts)
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(bookmarkItems, id: \.self) { chunk in
                    BookmarksView_List_Row(items: chunk, width: self.width)
                }
            }
        }.border(Color.black, width: 1)
    }
}

struct BookmarksView_List_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Previews.previews
    }
}
