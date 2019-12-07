//
//  TranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct EditorNSTextView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        Group {
            #if os(macOS)
            EditorNSTextRepresentable(translateAction: $store.translateAction)
            #else
            EmptyView()
            #endif
        }
    }
}

struct GTranslatorView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        WebViewContainer {
            GTranslatorRepresenter(selectedText: self.$store.translateAction)
        }
    }
}

struct GTranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        GTranslatorView()
    }
}
