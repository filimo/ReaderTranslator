//
//  ReaderView_PDF.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Pdf: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        VStack {
            if store.viewMode == .pdf {
                PDFKitView().padding(.bottom)
                ReaderView_Pdf_Toolbar().frame(height: 30)
            }
        }
    }
}

struct ReaderView_Pdf_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Pdf()
    }
}
