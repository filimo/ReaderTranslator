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
        bookmarkView
    }

    private var bookmarkView: some View {
        let text = self.store.translateAction.getText()

        return Group {
            if text != "" {
                if self.store.bookmarks.contains(text: text) {
                    Button(action: { self.store.bookmarks.remove(text: text) },
                           label: { Image.sfSymbol("bookmark.fill") })
                } else {
                    Button(
                        action: {
                            self.store.bookmarks.append(text)
                            self.store.translateAction.add(.bookmarks(text: text))
                        },
                        label: { Image.sfSymbol("bookmark") }
                    )
                }
            } else {
                EmptyView()
            }
        }
    }
}
