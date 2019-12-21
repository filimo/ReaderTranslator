//
//  ConnectionView_Bookmarks.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 22/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ConnectionView_Bookmarks: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        List {
            ForEach(store.bookmarks, id: \.self) { bookmark in
                Text("\(bookmark.text)")
            }
        }
    }
}
