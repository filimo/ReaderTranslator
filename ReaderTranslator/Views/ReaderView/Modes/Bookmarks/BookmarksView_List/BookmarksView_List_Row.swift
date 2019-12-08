//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct BookmarksView_List_Row: View {
    @ObservedObject var store = Store.shared

    @State var selectSentence = ""

    var bookmarks: Bookmarks
    var width: CGFloat

    var showDetail: Bool {
        self.bookmarks.contains(text: self.store.longmanSelectedBookmark)
    }

    var body: some View {
        VStack(alignment: .leading) {
            bookmarksView
            if showDetail {
                BookmarksView_List_Detail(selectSentence: $selectSentence)
            }
        }
    }

    private var bookmarksView: some View {
        HStack {
            ForEach(bookmarks, id: \.self) { bookmark in
                HStack {
                    Image.sfSymbol(bookmark.checked ? "checkmark.circle.fill" : "checkmark.circle")
                    .onTapGesture {
                        self.store.bookmarks.toggle(bookmark.text)
                    }
                    self.bookmarkView(bookmark: bookmark)
                }
            }
        }
    }

    private func bookmarkView(bookmark: Bookmark) -> some View {
        Text("\(bookmark.text)")
        .frame(width: self.width, alignment: .leading)
        .foregroundColor(self.store.longmanSelectedBookmark == bookmark.text ? Color.yellow : Color.primary)
        .onTapGesture {
            self.store.longmanSelectedBookmark = bookmark.text
            self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks, isSpeaking: false)
        }
    }
}
