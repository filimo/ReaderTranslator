//
//  ReaderView_PDF.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var store = Store.shared

    @State var selectedWord = ""

    var bookmarks: [Bookmarks] {
        if case let .bookmarks(text) = self.store.translateAction {
            Store.shared.translateAction.next()
            RunLoop.main.perform {
                self.selectedWord = text
            }
        }

        return self.store.bookmarks.sorted { $0.text.lowercased() < $1.text.lowercased() }.chunked(into: 3)
    }

    var body: some View {
        ScrollView {
            VStack {
                ForEach(bookmarks, id: \.self) { chunk in
                    HStack {
                        ForEach(chunk, id: \.self) { bookmark in
                            HStack {
                                Image.sfSymbol(bookmark.checked ? "checkmark.circle.fill" : "checkmark.circle")
                                .onTapGesture {
                                    self.store.bookmarks.toggle(bookmark.text)
                                }
                                Text("\(bookmark.text)")
                                .onTapGesture {
                                    self.selectedWord = bookmark.text
                                    self.store.translateAction.addAll(text: bookmark.text, except: .bookmarks)
                                }
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(self.selectedWord == bookmark.text ? Color.yellow : Color.primary)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
