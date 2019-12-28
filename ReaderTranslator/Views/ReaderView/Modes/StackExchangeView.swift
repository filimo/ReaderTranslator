//
//  StackExchangeView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 28/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StackExchangeView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            StackExchangeRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.stackExchange])
    }
}

struct StackExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        StackExchangeView()
    }
}
