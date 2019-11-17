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
        HStack {
            #if os(macOS)
            SafariView()
            #endif
            Group {
                if store.enabledViews.contains(.wikipedia) { WikipediaView() }
                if store.enabledViews.contains(.macmillan) { MacmillanView() }
                if store.enabledViews.contains(.collins) { CollinsView() }
                if store.enabledViews.contains(.longman) { LongmanView() }
                if store.enabledViews.contains(.reverso) { ReversoView() }
                if store.enabledViews.contains(.gTranslator) { GTranslatorView() }
                if store.enabledViews.contains(.yTranslator) { YTranslatorView() }
            }
            ReaderView_PDF()
            ReaderView_Web()
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView()
    }
}
