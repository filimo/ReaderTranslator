//
//  StatusBarView_Safari.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct StatusBarView_Safari: View {
    @EnvironmentObject var store: Store
    var body: some View {
        Group {
            #if os(macOS)
            Text("Safari plugin: \(store.canSafariSendSelectedText ? "on" : "off")")
                .foregroundColor(store.canSafariSendSelectedText ? .green : .red)
                .onTapGesture { self.store.canSafariSendSelectedText.toggle() }
            #endif
        }
    }
}

