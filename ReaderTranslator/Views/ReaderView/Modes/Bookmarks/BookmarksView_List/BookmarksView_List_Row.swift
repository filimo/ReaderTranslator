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
    @ObservedObject var longmanStore = LongmanStore.shared
    @ObservedObject var bookmarksStore = BookmarksStore.shared

    @State var selectSentence = ""

    var items: BookmarksStore.Bookmarks
    var width: CGFloat

    var showDetail: Bool {
        items.contains(text: longmanStore.word)
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
            ForEach(items, id: \.self) { bookmark in
                HStack {
                    CircleButton { Text("\(bookmark.counter)") }
                        .aspectRatio(contentMode: .fill)
                        .fixedSize(horizontal: true, vertical: false)
                        .onTapGesture {
                            self.bookmarksStore.items.increase(bookmark: bookmark)
                        }
                    self.bookmarkItemView(bookmark: bookmark).font(.headline)
                }
            }
        }
    }

    private func bookmarkItemView(bookmark: BookmarksStore.Bookmark) -> some View {
        Text("\(bookmark.text)")
            .frame(width: width, alignment: .leading)
            .foregroundColor(longmanStore.word == bookmark.text ? Color.yellow : Color.primary)
            .onTapGesture {
                self.longmanStore.word = bookmark.text
                self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks, isSpeaking: false)
            }
    }
}

struct BookmarksView_List_Row_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_List_Row(items: [.init(text: "test")], width: 100)
    }
}
