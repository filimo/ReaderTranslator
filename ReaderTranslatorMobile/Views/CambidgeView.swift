//
//  CambidgeView.swift
//  ReaderTranslatorIPad
//
//  Created by Viktor Kushnerov on 10/28/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct CambidgeView: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        CambidgeRepresenter(selectedText: self.$store.translateAction)
    }
}

struct CambidgeView_Previews: PreviewProvider {
    static var previews: some View {
        CambidgeView()
    }
}
