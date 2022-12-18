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

    @State var prefix = ""

    var body: some View {
        WebViewContainer {
            ChatGPTRepresenter(prefix: $prefix, selectedText: $store.translateAction)

            Menu(prefix) {
                buttonView(text: "Translate to english")
                buttonView(text: "Translate to russian")
                buttonView(text: "Error in Swift")
                buttonView(text: "Explain the following sentence")
                buttonView(text: "Explain english gramma")
                buttonView(text: "Исправь ошибки и раставь запятые")
                buttonView(text: "Как понять по русски?")
            }
        }
        .frame(width: viewsStore.viewWidth[.yTranslator] ?? ViewsStore.defaultWidth)
    }

    private func buttonView(text: String) -> some View {
        Button(text) {
            prefix = text
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
