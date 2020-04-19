//
//  GTranslatorView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct GTranslatorMiniView: View {
    @ObservedObject private var store: Store = .shared

    var body: some View {
        GTranslatorRepresenter(selectedText: self.$store.translateAction)
        .onAppear {
            GTranslatorRepresenter.isMiniMode = true
        }
    }
}

struct GTranslatorMiniView_Previews: PreviewProvider {
    static var previews: some View {
        GTranslatorMiniView()
    }
}
