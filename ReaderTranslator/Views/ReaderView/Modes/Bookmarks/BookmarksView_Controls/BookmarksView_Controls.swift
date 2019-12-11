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

    private var audioRateString: String {
        String(format: "%.1f", arguments: [self.store.longmanAudioRate])
    }

    private var bookmarks: Bookmarks {
        self.store.bookmarks.filter(counter: self.store.bookmarksCounterFilter)
    }

    var body: some View {
        VStack {
            HStack {
                MenuButton("counter \(self.store.bookmarksCounterFilter)") {
                    ForEach(0...5, id: \.self) { counter in
                        Button(
                            action: {
                                self.store.bookmarksCounterFilter = counter
                            },
                           label: { Text("\(counter)") })
                    }
                }.fixedSize()
                Text("\(bookmarks.count)/\(store.bookmarks.count)")
                BookmarksView_Controls_ActionMenu()
            }
            audioRateButtonsView
        }
    }

    private var audioRateButtonsView: some View {
        HStack {
            Button(action: { self.store.longmanAudioRate = 0.2 }, label: { Text(".2") })
            Button(action: { self.store.longmanAudioRate = 0.5 }, label: { Text(".5") })
            Button(action: { self.store.longmanAudioRate -= 0.1 }, label: { Text("-") })
            Text(audioRateString)
            Button(action: { self.store.longmanAudioRate += 0.1 }, label: { Text("+") })
            Button(action: { self.store.longmanAudioRate = 1 }, label: { Text("1") })
        }
    }
}

struct BookmarksView_Controls_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView_Controls()
    }
}
