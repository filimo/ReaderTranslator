//
//  ReaderView_PDF.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_PDF: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        VStack {
            if store.viewMode == .pdf {
                PDFKitView()
                PdfToolbarView().frame(height: 30)
            }
        }
    }
}

struct ReaderView_PDF_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_PDF()
    }
}
