//
//  BookmarksView_List.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView_Controls: View {
    @ObservedObject var store = Store.shared

    @State var showConfirm = false

    var body: some View {
        HStack {
            Text("\(store.bookmarks.count)")
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

struct BookmarksView_Controls_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Controls()
    }
}
