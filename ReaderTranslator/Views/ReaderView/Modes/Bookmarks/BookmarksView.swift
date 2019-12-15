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
        }.frame(width: (bookmarkWidth + 30) * CGFloat(columnts))
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store.shared
        let url = URL(fileURLWithPath: "")
        store.longmanSelectedBookmark = "aunt"
        store.longmanSentences = [
            LongmanSentence(text: "Sentence 1", url: url),
            LongmanSentence(
                text: """
                Sentence2 long1 long2 long3 long4 long5
                long6 long7 long8 long9 long10 long11
                long12 long13 long14 long15 long16 long5
                """.replacingOccurrences(of: "\n", with: ""),
                url: url
            ),
            LongmanSentence(text: "Sentence 3", url: url),
            LongmanSentence(text: "Sentence 4", url: url),
            LongmanSentence(text: "Sentence 5", url: url),
            LongmanSentence(text: "Sentence 6", url: url)
        ]

        return BookmarksView()
    }
}
