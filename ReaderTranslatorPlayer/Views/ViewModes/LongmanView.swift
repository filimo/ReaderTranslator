//
//  LongmanView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 15/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct LongmanView: View {
    var phrase: String

    @ObservedObject var store = Store.shared

    var body: some View {
        LongmanRepresenter(phrase: phrase)
            .onAppear {
                self.store.hideNavBar = false
                if self.store.bookmarks.longmanSelectedBookmark != self.phrase {
                    RunLoop.main.perform {
                        self.store.bookmarks.longmanSelectedBookmark = self.phrase
                    }
                }
            }
    }
}

struct LongmanView_Previews: PreviewProvider {
    static var previews: some View {
        LongmanView(phrase: "test")
    }
}
