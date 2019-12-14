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

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(store.bookmarks, id: \.self) { bookmark in
                        HStack {
                            NavigationLink(
                                destination: LongmanRepresenter().navigationBarHidden(false),
                                label: {  Text(bookmark.text).font(.largeTitle) })
                            NavigationLink(
                                destination: SentencesView(bookmark: bookmark.text),
                                label: {  self.bookmarksIco })
                            Spacer()
                            self.counterImageIco(counter: bookmark.counter)
                                .onTapGesture { self.store.bookmarks.increase(bookmark: bookmark) }
                        }
                    }
                }
            }
        }.padding()
    }

    private var bookmarksIco: some View {
        return Image(systemName: "book.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 10)
    }

    private func counterImageIco(counter: Int) -> some View {
        let name = counter == 0 ? "0.circle" : "\(counter).circle.fill"
        return Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 5)
    }
}
