//
//  TranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct YTranslatorView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            YTranslatorRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.yTranslator])
    }
}

struct YTranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        YTranslatorView()
    }
}
