//
//  MerriamWebsterView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 20/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct MerriamWebsterView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            MerriamWebsterRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.merriamWebster] ?? ViewsStore.defaultWidth)
    }
}
