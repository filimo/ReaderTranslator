//
//  bookmarksView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 14/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var bookmarksStore = BookmarksStore.shared

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(store.bookmarks, id: \.self) { bookmark in
                        HStack {
                            NavigationLink(
                                destination: SentencesView(bookmark: bookmark.text),
                                label: {
                                    Text(bookmark.text)
                                        .font(.title)
                                        .lineLimit(1)
                                }
                            ).layoutPriority(2)
                            bookmarksIco(text: bookmark.text)

                            Spacer()

                            CircleButton {
                                Text("\(bookmark.counter)").font(.footnote)
                            }
                            .modifier(ButtonModifier())
                            .onTapGesture {
                                self.bookmarksStore.items.increase(bookmark: bookmark)
                            }
                        }
                    }
                }
            }
        }.padding()
    }

    private func bookmarksIco(text: String) -> some View {
        NavigationLink(
            destination: LongmanView(phrase: text),
            label: {
                Image(systemName: "book.circle")
                    .resizable()
                    .modifier(ButtonModifier())
            }
        )
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        Store.shared.bookmarks = [.init(counter: 11, text: "test bookmark test test")]
        return BookmarksView()
    }
}
