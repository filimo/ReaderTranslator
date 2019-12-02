//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct CollinsView: View {
    @ObservedObject private var store = Store.shared
    @State var width: CGFloat?

    var body: some View {
        WebViewContainer {
            Collins(selectedText: self.$store.translateAction)
        }.frame(width: store.maxViewWidth)
    }
}

struct CollinsView_Previews: PreviewProvider {
    static var previews: some View {
        MacmillanView()
    }
}
