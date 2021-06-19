//
//  BookmarksView_List_Chunk.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 7/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI

struct BookmarksView_List_Detail: View {
    @ObservedObject var store = Store.shared
    @ObservedObject var longmanStore = LongmanStore.shared
    @ObservedObject var bookmarksStore = BookmarksStore.shared

    @Binding var selectSentence: String

    var changedTime: String {
        guard let bookmark = bookmarksStore.items.first(text: longmanStore.word) else {
            return ""
        }
        return RelativeDateTimeFormatter().localizedString(for: Date(), relativeTo: bookmark.lastCreatedLog)
    }

    var createTime: String {
        guard let bookmark = bookmarksStore.items.first(text: longmanStore.word) else {
            return ""
        }
        return RelativeDateTimeFormatter().localizedString(for: Date(), relativeTo: bookmark.created)
    }

    var body: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    Text("counter changed: \(changedTime)").foregroundColor(Color.purple)
                    Text("create: \(createTime)")
                }
                Text(longmanStore.word).font(.title)
                if longmanStore.sentences.isEmpty {
                } else {
                    ScrollView(.horizontal) {
                        sentencesView
                            .padding(.leading, 5)
                            .padding(.bottom, 15)
                    }
                }
            }
        }
    }

    var sentencesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(longmanStore.sentences, id: \.self) { sentence in
                Text("\(sentence.text)")
                    .foregroundColor(self.selectSentence == sentence.text ? Color.yellow : Color.primary)
                    .font(.subheadline)
                    .onTapGesture {
                        self.selectSentence = sentence.text
                        AudioStore.shared.addAudio(url: sentence.url)
                        AudioStore.shared.play()
                        self.store.translateAction.add(.gTranslator(text: sentence.text), isSpeaking: false)
                    }
            }
        }
    }
}

struct BookmarksView_List_Detail_Preview: PreviewProvider {
    static var previews: some View {
        LongmanStore.shared.word = "sanctuary"
        LongmanStore.shared.sentences = [
            .init(text: "The park is the largest wildlife sanctuary in the US.", url: URL.empty),
            .init(text: "a sanctuary for tigers", url: URL.empty)
        ]

        return BookmarksView_List_Detail(selectSentence: .constant("sanctuary"))
    }
}
