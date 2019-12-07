//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct BookmarksView_List_Chunk: View {
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
            if showDetail { detailView }
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
            self.store.longmanSentences = []
            self.store.longmanSelectedBookmark = bookmark.text
            self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks, isSpeaking: false)
            LongmanStore.share.fetchInfo(text: bookmark.text)
        }
    }

    private var detailView: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                ForEach(store.longmanSentences, id: \.self) { sentence in
                    Text("\(sentence.text)")
                    .foregroundColor(self.selectSentence == sentence.text ? Color.yellow : Color.primary)
                    .onTapGesture {
                        self.selectSentence = sentence.text
                        LongmanStore.share.addAudio(url: sentence.url )
                    }
                }
            }.padding(.bottom)
        }
    }
}
