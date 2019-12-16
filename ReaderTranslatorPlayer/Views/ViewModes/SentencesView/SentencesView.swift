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
    let bookmark: String
    @State var showGTranlator: LongmanSentence?
    @State var showLongmanView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(store.longmanSentences, id: \.self) { sentence in
                        SentencesView_Row(
                            sentence: sentence,
                            showGTranlator: self.$showGTranlator,
                            showLongmanView: self.$showLongmanView)
                    }
                }
            }
            navigationLinksView
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

    private var navigationLinksView: some View {
        Group {
            if showGTranlator != nil {
                NavigationLink(
                    destination: GTranslatorView(sentence: showGTranlator ?? LongmanSentence.empty),
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
    }
}
