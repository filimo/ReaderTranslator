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
    @State var showConfirm = false
    @State var filter = ""

    private let bookmarkWidth: CGFloat = 100

    var body: some View {
        VStack {
            TextField("", text: $filter).frame(width: bookmarkWidth * 3)
            BookmarksView_List(width: bookmarkWidth, filter: $filter, selectedWord: $selectedWord)
            HStack {
                Button(action: {
                    self.showConfirm = true
                }, label: { Text("Remove all") })
                Button(action: {
                    let items = Clipboard.string.split(separator: "\n")
                    self.store.bookmarks.append(items: items)
                }, label: { Text("Paste to") })
                Button(action: {
                    Clipboard.copy(self.store.bookmarks.joined(separator: "\n"))
                }, label: { Text("Copy to") })
            }
            .alert(isPresented: $showConfirm) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Remove all bookmarks?"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Ok")) {  self.store.bookmarks.removeAll() })
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
