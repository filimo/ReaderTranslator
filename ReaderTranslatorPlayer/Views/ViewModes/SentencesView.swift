//
//  SentencesView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 14/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SentencesView: View {
    @ObservedObject var store = Store.shared
    var bookmark: String
    @State var sentence = ""

    var body: some View {
        VStack {
            List {
                ForEach(store.longmanSentences, id: \.self) { sentence in
                    HStack {
                        NavigationLink(destination: LongmanRepresenter(), label: {
                            Text(sentence.text)
                            self.soundIco
                                .onTapGesture {
                                    LongmanStore.share.addAudio(url: sentence.url)
                                    LongmanStore.share.next()
                            }
                        })
                    }
                }
            }
        }
        .onAppear {
            self.store.hideNavBar = false
            if self.store.longmanSelectedBookmark != self.bookmark {
                RunLoop.main.perform {
                    self.store.longmanSelectedBookmark = self.bookmark
                }
            }
        }
    }

    private var soundIco: some View {
        Image(systemName: "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 10)
    }

    private var bookmarksIco: some View {
        Image(systemName: "book.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 10)
    }

    private func getColor(sentence: String) -> Color {
        self.sentence == sentence ? Color.yellow : Color.primary
    }
}
