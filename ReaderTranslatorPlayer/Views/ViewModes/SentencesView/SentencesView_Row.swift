//
//  SentencesView_Row.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 16/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SentencesView_Row: View {
    let sentence: LongmanSentence
    @Binding var showGTranlator: LongmanSentence?
    @Binding var showLongmanView: Bool

    @ObservedObject var store = Store.shared

    var body: some View {
        HStack {
            Button(action: {
                LongmanStore.share.addAudio(url: self.sentence.url)
                LongmanStore.share.next()
            }, label: { self.soundIco })
            Button(
                action: { self.showGTranlator = self.sentence },
                label: { Text(self.sentence.text).font(.headline) })
            Spacer()
            Button(action: { self.showLongmanView = true }, label: { self.longmanIco })
        }.padding(.leading, 10)
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
}

struct SentencesView_Row_Previews: PreviewProvider {
    @ObservedObject var store = Store.shared

    init() {
//        let bookmarks: Bookmarks = [
//            .init(counter: 1, text: "work 1", created: Date(), changed: Date()),
//            .init(counter: 1, text: "work 2", created: Date(), changed: Date()),
//            .init(counter: 1, text: "work 3", created: Date(), changed: Date())
//        ]
//        if store.bookmarks.isEmpty { store.bookmarks = bookmarks }
    }

    static var previews: some View {
        SentencesView_Row(
            sentence: LongmanSentence(text: "test", url: URL.empty),
            showGTranlator: .constant(nil),
            showLongmanView: .constant(false))
    }
}
