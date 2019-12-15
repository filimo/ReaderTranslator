//
//  LongmanView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 15/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct LongmanView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        LongmanRepresenter()
            .onAppear {
                self.store.hideNavBar = false
            }
    }
}

struct LongmanView_Previews: PreviewProvider {
    static var previews: some View {
        LongmanView()
    }
}
