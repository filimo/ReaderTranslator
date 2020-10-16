//
//  ReversoView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReversoView: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        ReversoRepresenter(selectedText: self.$store.translateAction)
    }
}

struct ReversoView_Previews: PreviewProvider {
    static var previews: some View {
        ReversoView()
    }
}
