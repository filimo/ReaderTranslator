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
                Button("None") {
                    prefix = ""
                }

                ForEach(commands, id: \.self) { text in
                    Button(text) {
                        prefix = text
                    }
                }
            }
        }
        .frame(width: viewsStore.viewWidth[.chatGPT] ?? ViewsStore.defaultWidth)
    }

    private let commands = [
        "What is it",

        "Translate and show as a table with origin and russian",
        "Translate to english",
        "Translate to english",

        "Explain the following sentence",
        "Explain english gramma",

        "Error in Swift",

        "Summarize this with 1000 words",
        "Summarize this for a second-grade student",

        "Исправь ошибки и раставь запятые",
        "Как понять по русски?"
    ]
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView()
    }
}
