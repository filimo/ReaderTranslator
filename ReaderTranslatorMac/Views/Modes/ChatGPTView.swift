//
//  ChatGPTView.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 15.12.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ChatGPTView: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject private var viewsStore = ViewsStore.shared

    var body: some View {
        WebViewContainer {
            ChatGPTRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: viewsStore.viewWidth[.yTranslator] ?? ViewsStore.defaultWidth)
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
