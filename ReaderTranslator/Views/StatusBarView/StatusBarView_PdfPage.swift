//
//  StatusBarView_PdfPage.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_PdfPage: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        return Group {
            if store.viewMode == .pdf {
                Text("  Page:")
                #if os(macOS)
                TextField("   ", text: self.$store.currentPage)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                #else
                TextField("   ", text: self.$store.currentPage)
                    .fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                #endif
                Text(" / \(self.store.pageCount)")
            }
        }
    }
}

struct StatusBarView_PdfPage_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_PdfPage()
    }
}
