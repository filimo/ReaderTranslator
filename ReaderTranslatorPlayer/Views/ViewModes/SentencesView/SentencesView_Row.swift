//
//  SentencesView_Row.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 16/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct SentencesView_Row: View {
    let sentence: LongmanSentence

    @Binding var showGTranlator: LongmanSentence?
    @Binding var showLongmanView: Bool

    @State var cancellableSpeakers: AnyCancellable?

    @ObservedObject var store = Store.shared

    var body: some View {
        HStack {
            Button(action: {
                cancellableSpeakers = Publishers
                    .CombineLatest3(
                        LongmanStore.shared.fetchInfo(text: sentence.text),
                        CambridgeStore.shared.fetchInfo(text: sentence.text),
                        CollinsStore.shared.fetchInfo(text: sentence.text))
                    .sink { hasLongmanSound, hasCambridgeSound, hasCollinsSound in
                        if hasCambridgeSound {
                            AudioStore.shared.play()
                        } else if hasLongmanSound {
                            AudioStore.shared.play()
                        } else if hasCollinsSound {
                            AudioStore.shared.play()
                        } 
                    }
            }, label: { soundIco })
            Button(
                action: { showGTranlator = sentence },
                label: { Text(sentence.text).font(.headline) })
            Spacer()
            Button(action: { showLongmanView = true }, label: { longmanIco })
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

    static var previews: some View {
        SentencesView_Row(
            sentence: LongmanSentence(text: "test", url: URL.empty),
            showGTranlator: .constant(nil),
            showLongmanView: .constant(false))
    }
}
