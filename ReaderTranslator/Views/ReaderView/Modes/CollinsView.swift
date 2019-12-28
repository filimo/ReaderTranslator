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
    @ObservedObject private var viewsStore = ViewsStore.shared
    @State var width: CGFloat?

    var body: some View {
        WebViewContainer {
            CollinsRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.collins])
    }
}

struct CollinsView_Previews: PreviewProvider {
    static var previews: some View {
        MacmillanView()
    }
}
