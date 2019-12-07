//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReversoView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        WebViewContainer {
            ReversoRepresenter(selectedText: self.$store.translateAction)
        }
    }
}

struct ReversoView_Previews: PreviewProvider {
    static var previews: some View {
        ReversoView()
    }
}
