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
            PDFKitView()
            ReaderView_Pdf_Toolbar()
        }.frame(width: AvailableView.pdf.width.wrappedValue.cgFloatValue)
    }
}

struct ReaderView_Pdf_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Pdf()
    }
}
