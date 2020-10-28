//
//  CollinsView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct CollinsView: View {
    @ObservedObject private var store = Store.shared
    
    var body: some View {
        CollinsRepresenter(selectedText: self.$store.translateAction)
    }
}

struct CollinsView_Previews: PreviewProvider {
    static var previews: some View {
        CollinsView()
    }
}
