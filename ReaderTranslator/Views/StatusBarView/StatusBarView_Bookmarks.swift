//
//  StatusBarView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Bookmarks: View {
    @ObservedObject var store = Store.shared
    @State var show: Bool = false

    var body: some View {
        Group {
            Divider().fixedSize()
            self.bookmarkView
            Button(action: { self.show = true }, label: { Text(show ? "􀉛" : "􀉚") })
        }
        .sheet(isPresented: $show) {
            self.listView
        }
    }

    private var bookmarkView: some View {
        let text = self.store.translateAction.getText()

        return Group {
            if text != "" {
                if self.store.bookmarks.contains(text) {
                    Button(action: { self.store.bookmarks.remove(object: text)},
                           label: { Image.sfSymbol("bookmark.fill") })
                } else {
                    Button(action: { self.store.bookmarks.append(text) },
                           label: { Image.sfSymbol("bookmark") })
                }
            } else {
                EmptyView()
            }
        }
    }

    private var listView: some View {
        let bookmarks = self.store.bookmarks.sorted { $0.lowercased() < $1.lowercased() }.chunked(into: 8)

        return VStack {
            HStack {
                ScrollView {
                    ForEach(bookmarks, id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.self) { text in
                                Text("\(text)").onTapGesture {
                                    self.store.translateAction.addAll(text: text)
                                    self.show = false
                                }.frame(width: 100)
                            }
                        }
                    }
                }.frame(height: 800)
            }
            HStack {
                Button(action: { Clipboard.copy(self.store.bookmarks.joined(separator: "\n"))},
                       label: { Image.sfSymbol("doc.on.clipboard") })
                Button(action: { self.show = false },
                       label: { Image.sfSymbol("xmark.circle") })
            }
        }
    }
}
