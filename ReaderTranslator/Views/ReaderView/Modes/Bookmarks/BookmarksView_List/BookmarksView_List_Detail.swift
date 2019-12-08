//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import Combine

struct BookmarksView_List_Detail: View {
    @ObservedObject var store = Store.shared

    @Binding var selectSentence: String

    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                ForEach(store.longmanSentences, id: \.self) { sentence in
                    Text("\(sentence.text)")
                    .foregroundColor(self.selectSentence == sentence.text ? Color.yellow : Color.primary)
                    .onTapGesture {
                        self.selectSentence = sentence.text
                        LongmanStore.share.addAudio(url: sentence.url )
                        LongmanStore.share.next()
                        self.store.translateAction.add(.gTranslator(text: sentence.text), isSpeaking: false)
                    }
                }
            }
            .padding()
        }
    }
}
