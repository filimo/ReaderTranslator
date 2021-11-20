//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct LongmanView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            LongmanRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.longman] ?? ViewsStore.defaultWidth)
    }
}

struct LongmanView_Previews: PreviewProvider {
    static var previews: some View {
        LongmanView()
    }
}
