//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReversoView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            ReversoRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.reverso] ?? ViewsStore.defaultWidth)
    }
}

struct ReversoView_Previews: PreviewProvider {
    static var previews: some View {
        ReversoView()
    }
}
