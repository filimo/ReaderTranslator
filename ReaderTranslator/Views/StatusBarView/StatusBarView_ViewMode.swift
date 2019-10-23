//
//  StatusBarView_PdfMode.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_ViewMode: View {
    @ObservedObject var store = Store.shared
    
    var body: some View {
        HStack(spacing: 5) {
            button(mode: .pdf)
            button(mode: .web)
            #if os(macOS)
            button(mode: .safari)
            #endif
        }
    }
    
    private func button(mode: ViewMode) -> some View {
        Button(action: {
            RunLoop.main.perform {
                self.store.viewMode = mode
            }
        }, label: {
            Text(mode.rawValue)
        })
        .background(self.store.viewMode == mode ? Color.red : Color.clear)
    }
}

struct StatusBarView_PdfMode_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView_ViewMode()
    }
}
