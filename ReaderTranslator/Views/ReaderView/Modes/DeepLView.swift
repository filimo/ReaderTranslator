//
//  DeepLView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/3/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct DeepLView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared
    @State var width: CGFloat?

    var body: some View {
        WebViewContainer {
            DeepLRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.deepL] ?? ViewsStore.defaultWidth)
    }
}

struct DeepLView_Previews: PreviewProvider {
    static var previews: some View {
        DeepLView()
    }
}
