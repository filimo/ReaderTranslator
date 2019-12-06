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

    var width: CGFloat
    @Binding var filter: String
    @Binding var selectedWord: String

    private var bookmarks: [Bookmarks] {
        if case let .bookmarks(text) = self.store.translateAction {
            Store.shared.translateAction.next()
            RunLoop.main.perform {
                self.selectedWord = text
            }
        }

        var bookmarks = self.store.bookmarks
        let filter = self.filter.trimmingCharacters(in: .whitespaces)

        if !filter.isEmpty {
             bookmarks = bookmarks.filter { $0.text.contains(filter) }
        }

        return bookmarks.chunked(into: 3)
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(bookmarks, id: \.self) { chunk in
                    self.chunkView(chunk: chunk)
                }
            }
        }
    }

    private func chunkView(chunk: Bookmarks) -> some View {
        HStack {
            ForEach(chunk, id: \.self) { bookmark in
                HStack {
                    Image.sfSymbol(bookmark.checked ? "checkmark.circle.fill" : "checkmark.circle")
                    .onTapGesture {
                        self.store.bookmarks.toggle(bookmark.text)
                    }
                    Text("\(bookmark.text)")
                    .frame(width: self.width, alignment: .leading)
                    .foregroundColor(self.selectedWord == bookmark.text ? Color.yellow : Color.primary)
                    .onTapGesture {
                        self.selectedWord = bookmark.text
                        self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks)
                    }
                }
            }
        }
    }
}

struct BookmarksView_List_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_List(width: 100, filter: .constant(""), selectedWord: .constant(""))
    }
}
