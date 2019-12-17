//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI

struct BookmarksView_List_Row: View {
    @ObservedObject var store = Store.shared

    @State var selectSentence = ""

    var bookmarks: Bookmarks
    var width: CGFloat

    var showDetail: Bool {
        bookmarks.contains(text: store.longmanSelectedBookmark)
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
                    CircleButton { Text("\(bookmark.counter)") }
                        .aspectRatio(contentMode: .fill)
                        .fixedSize(horizontal: true, vertical: false)
                        .onTapGesture {
                            self.store.bookmarks.increase(bookmark: bookmark)
                        }
                    self.bookmarkItemView(bookmark: bookmark).font(.headline)
                }
            }
        }
    }

    private func bookmarkItemView(bookmark: Bookmark) -> some View {
        Text("\(bookmark.text)")
            .frame(width: width, alignment: .leading)
            .foregroundColor(store.longmanSelectedBookmark == bookmark.text ? Color.yellow : Color.primary)
            .onTapGesture {
                self.store.longmanSelectedBookmark = bookmark.text
                self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks, isSpeaking: false)
            }
    }
}

struct BookmarksView_List_Row_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_List_Row(bookmarks: [.init(text: "test")], width: 100)
    }
}
