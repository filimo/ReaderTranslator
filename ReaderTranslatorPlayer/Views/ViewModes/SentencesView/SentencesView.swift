//
//  SentencesView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 14/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI

private var cancellableLongmanSpeak: AnyCancellable?

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
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            navigationLinksView
        }
        .onAppear {
            self.store.hideNavBar = false
            cancellableLongmanSpeak = LongmanStore.shared.fetchInfo(text: self.bookmark)
                .sink { isSoundExist in
                    if isSoundExist {
                        LongmanStore.shared.play()
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
                    destination: LongmanView(phrase: self.bookmark),
                    isActive: .constant(true),
                    label: { EmptyView() })
            }
        }
    }
}
