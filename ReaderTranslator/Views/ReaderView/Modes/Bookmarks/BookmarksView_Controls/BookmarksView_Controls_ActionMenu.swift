//
//  BookmarksView_Controls_ActionMenu.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView_Controls_ActionMenu: View {
    @ObservedObject var store = Store.shared
    @State var showConfirm = false

    var body: some View {
        MenuButton("Actions") {
            Button(action: {
                self.store.bookmarks.clearAllCounters()
            }, label: { Text("Clear all counters") })
            Button(action: {
                Clipboard.copy(self.store.bookmarks.joined(separator: "\n"))
            }, label: { Text("Copy bookmarks to Clipboard") })
            Button(action: {
                let items = Clipboard.string.split(separator: .BackslashN)
                self.store.bookmarks.append(items: items)
            }, label: { Text("Paste bookmarks separated by \\n from Clipboard") })
            Button(action: {
                self.showConfirm = true
            }, label: { Text("Remove all bookmarks") })
        }
        .fixedSize()
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .padding([.leading, .trailing], 5)
        .background(RoundedRectangle(cornerRadius: 3).foregroundColor(Color(NSColor.controlColor)))
        .alert(isPresented: $showConfirm) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Remove all bookmarks?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Ok")) {  self.store.bookmarks.removeAll() })
        }
    }
}

struct BookmarksView_Controls_ActionMenu_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Controls_ActionMenu()
    }
}
