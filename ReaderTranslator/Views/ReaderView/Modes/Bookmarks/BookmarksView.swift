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

    @State var filter = ""

    private let bookmarkWidth: CGFloat = 100
    private let columnts = 3
    private var width: CGFloat { bookmarkWidth * CGFloat(columnts) }

    var body: some View {
        VStack {
            TextField("", text: $filter).frame(width: bookmarkWidth * CGFloat(columnts))
            BookmarksView_List(columnts: columnts, width: bookmarkWidth, filter: $filter)
            BookmarksView_Controls()
        }.frame(width: (bookmarkWidth + 50) * CGFloat(columnts))
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
