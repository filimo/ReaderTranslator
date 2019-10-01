//
//  StatusBarView_PdfMode.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_ViewMode: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        let pdfMode = Binding<Bool>(
            get: { self.store.viewMode == .pdf },
            set: { self.store.viewMode = $0 ? .pdf : .web }
        )
        
        return Group {
            Toggle(isOn: pdfMode) {
                Text("WEB")
            }.fixedSize()
            Text("PDF")
        }
    }
}

struct StatusBarView_PdfMode_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_ViewMode().environmentObject(Store.shared)
    }
}
