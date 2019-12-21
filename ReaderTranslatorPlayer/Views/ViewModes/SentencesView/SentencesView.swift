//
//  SentencesView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 14/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SentencesView: View {
    let bookmark: String

    @ObservedObject var store = Store.shared
    @ObservedObject var longmanStore = LongmanStore.shared

    @State var showGTranlator: LongmanSentence?
    @State var showLongmanView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(longmanStore.sentences, id: \.self) { sentence in
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
            if self.longmanStore.word != self.bookmark {
                RunLoop.main.perform {
                    self.longmanStore.word = self.bookmark
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
                    destination: LongmanView(phrase: longmanStore.word),
                    isActive: .constant(true),
                    label: { EmptyView() })
            }
        }
    }
}
