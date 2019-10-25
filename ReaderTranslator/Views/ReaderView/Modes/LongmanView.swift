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

    var body: some View {
        VStack {
            /** Hack: it or `Divider()` required to display GTranslatorView properly `Divider()` takes more space **/
            Text("").frame(height: 1)
            Longman(selectedText: $store.translateAction)
        }.frame(width: store.maxViewWidth)
    }
}

struct LongmanView_Previews: PreviewProvider {
    static var previews: some View {
        LongmanView()
    }
}
