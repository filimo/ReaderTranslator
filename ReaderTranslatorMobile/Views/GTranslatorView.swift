//
//  GTranslatorView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct GTranslatorView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        GTranslatorRepresenter(selectedText: self.$store.translateAction)
    }
}

struct GTranslatorView_Previews: PreviewProvider {
    static var previews: some View {
        GTranslatorView()
    }
}
