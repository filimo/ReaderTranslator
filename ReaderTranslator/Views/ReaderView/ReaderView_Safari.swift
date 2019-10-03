//
//  ReaderView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Safari: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        Group {
            #if os(macOS)
            if store.viewMode == .safari {
                Text(store.selectedText)
            }
            #endif
        }
        .onAppear {
            SafariExtensionManager().start(onMessageChanged: { notificationName in
                self.store.selectedText = SharedContainer.string()
            })
        }
    }
}

struct ReaderView_Safari_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Safari()
            .frame(maxWidth: 100)
            .environmentObject(Store.shared)
    }
}
