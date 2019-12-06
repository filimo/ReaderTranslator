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
    @State var filter = ""

    private let bookmarkWidth: CGFloat = 100
    private let columnts = 2

    var body: some View {
        VStack {
            TextField("", text: $filter).frame(width: bookmarkWidth * CGFloat(columnts))
            BookmarksView_List(columnts: 2, width: bookmarkWidth, filter: $filter, selectedWord: $selectedWord)
            BookmarksView_Controls()
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
