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

    struct ButtonModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .aspectRatio(contentMode: .fit)
                .fixedSize(horizontal: true, vertical: false)
                .padding([.top, .bottom], 8)
        }
    }

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
                                        .font(.largeTitle)
                                        .lineLimit(1)
                                }
                            ).layoutPriority(2)
                            self.bookmarksIco(text: bookmark.text)

                            Spacer()

                            CircleButton {
                                Text("\(bookmark.counter)")
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
        Store.shared.bookmarks = [.init(text: "test bookmark test test")]
        return BookmarksView()
    }
}
