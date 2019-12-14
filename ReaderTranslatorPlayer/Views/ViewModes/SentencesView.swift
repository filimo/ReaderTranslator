//
//  SentencesView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 14/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct SentencesView: View {
    @ObservedObject var store = APStore.shared
    var bookmark: String
    
    var body: some View {
        VStack {
            List {
                ForEach(store.longmanSentences, id: \.self) { sentence in
                    HStack {
                        NavigationLink(destination: LongmanRepresenter(), label: { Text(sentence.text) })
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(false)
        .onAppear {
            self.store.hideNavBar = false
            if self.store.longmanSelectedBookmark != self.bookmark {
                RunLoop.main.perform {
                    self.store.longmanSelectedBookmark = self.bookmark
                }
            }
        }
    }
}
