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
    @State var showGTranlator: LongmanSentence?
    @State var showLongmanView = false

    var body: some View {
        VStack {
            List {
                ForEach(store.longmanSentences, id: \.self) { sentence in
                    VStack {
                        self.controlView(sentence: sentence)
                    }
                }
            }
            if showGTranlator != nil {
                NavigationLink(
                    destination: GTranslatorView(
                        sentence: showGTranlator ?? LongmanSentence.empty),
                    isActive: .constant(true),
                    label: { EmptyView() })
            }
            if showLongmanView {
                NavigationLink(
                    destination: LongmanView(phrase: store.longmanSelectedBookmark),
                    isActive: .constant(true),
                    label: { EmptyView() })
            }
        }
        .onAppear {
            self.store.hideNavBar = false
            if self.store.longmanSelectedBookmark != self.bookmark {
                RunLoop.main.perform {
                    self.store.longmanSelectedBookmark = self.bookmark
                }
            }
            self.showGTranlator = nil
            self.showLongmanView = false
        }
    }

    private func controlView(sentence: LongmanSentence) -> some View {
        HStack {
            self.soundIco
                .onTapGesture {
                    LongmanStore.share.addAudio(url: sentence.url)
                    LongmanStore.share.next()
                }
            Text(sentence.text).onTapGesture {
                self.showGTranlator = sentence
            }
            Spacer()
            longmanIco.onTapGesture { self.showLongmanView = true }
        }
    }

    private var soundIco: some View {
        Image(systemName: "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 25)
            .padding(.trailing, 10)
    }

    private var longmanIco: some View {
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
