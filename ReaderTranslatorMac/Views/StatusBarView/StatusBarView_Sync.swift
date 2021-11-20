//
//  StatusBarView_Listener.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 12/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Sync: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var bookmarksStore = BookmarksStore.shared
    @ObservedObject var server = Server()

    var body: some View {
        HStack {
            Text(server.status.status).onTapGesture(perform: server.start)
            if server.status == .connected {
                Button(action: {
                    sharedConnection?.sendBookmarks(self.bookmarksStore.items.json)
                }, label: { Text("Sync bookmarks") })
            }
        }
    }
}

struct StatusBarView_Listener_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_Sync()
    }
}
