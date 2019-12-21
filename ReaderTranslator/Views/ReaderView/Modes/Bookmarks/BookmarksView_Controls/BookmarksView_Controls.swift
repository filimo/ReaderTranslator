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
    @ObservedObject var bookmarksStore = BookmarksStore.shared
    @ObservedObject var longmanStore = LongmanStore.shared

    private var audioRateString: String {
        String(format: "%.1f", arguments: [self.longmanStore.audioRate])
    }

    private var bookmarks: BookmarksStore.Bookmarks {
        bookmarksStore.items.filter(counter: bookmarksStore.filterCounter)
    }

    var body: some View {
        VStack {
            HStack {
                MenuButton("counter \(filterString(self.bookmarksStore.filterCounter))") {
                    ForEach(-1 ... 5, id: \.self) { counter in
                        Button(
                            action: {
                                self.bookmarksStore.filterCounter = counter
                            },
                            label: { Text(self.filterString(counter)) }
                        )
                    }
                }.fixedSize()
                Text("\(bookmarks.count)/\(bookmarksStore.items.count)")
                BookmarksView_Controls_ActionMenu()
            }
            audioRateButtonsView
        }
    }

    private var audioRateButtonsView: some View {
        HStack {
            Button(action: { self.longmanStore.audioRate = 0.2 }, label: { Text(".2") })
            Button(action: { self.longmanStore.audioRate = 0.5 }, label: { Text(".5") })
            Button(action: { self.longmanStore.audioRate -= 0.1 }, label: { Text("-") })
            Text(audioRateString)
            Button(action: { self.longmanStore.audioRate += 0.1 }, label: { Text("+") })
            Button(action: { self.longmanStore.audioRate = 1 }, label: { Text("1") })
        }
    }

    private func filterString(_ counter: Int) -> String {
        "\(counter == -1 ? "All" : String(counter))"
    }
}

struct BookmarksView_Controls_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Controls()
    }
}
