//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReaderView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                #if os(macOS)
                SafariView()
                #endif
                Group {
                    if store.enabledViews.contains(.bookmarks) { BookmarksView() }

                    Group {
                        if store.enabledViews.contains(.wikipedia) { WikipediaView() }
                        if store.enabledViews.contains(.macmillan) { MacmillanView() }
                        if store.enabledViews.contains(.collins) { CollinsView() }
                        if store.enabledViews.contains(.longman) { LongmanView() }
                        if store.enabledViews.contains(.reverso) { ReversoView() }
                        if store.enabledViews.contains(.gTranslator) { GTranslatorView() }
                        if store.enabledViews.contains(.yTranslator) { YTranslatorView() }
                    }

                    Group {
                        if store.enabledViews.contains(.pdf) { ReaderView_Pdf() }
                        if store.enabledViews.contains(.web) { ReaderView_Web() }
                        if store.enabledViews.contains(.safari) { SafariView() }
                    }
                }
            }.padding(.bottom, 20)
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView()
    }
}
