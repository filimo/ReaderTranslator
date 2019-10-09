//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReaderView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        HStack {
            ReaderView_PDF()
            ReaderView_Web()
            #if os(macOS)
            ReaderView_Safari()
            #endif
            TranslatorView()
            ReversoContextView()
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView().environmentObject(Store.shared)
    }
}
