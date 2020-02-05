//
//  LongmanView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 15/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI

private var cancellableLongmanSpeak: AnyCancellable?

struct LongmanView: View {
    var phrase: String

    @ObservedObject var store = Store.shared
    @ObservedObject var longmanStore = LongmanStore.shared

    var body: some View {
        LongmanRepresenter(phrase: phrase)
            .onAppear {
                self.store.hideNavBar = false
                cancellableLongmanSpeak = self.longmanStore.fetchInfo(text: self.phrase)
                .sink { isSoundExist in
                    if isSoundExist {
                        LongmanStore.shared.play()
                    }
                }
            }
    }
}

struct LongmanView_Previews: PreviewProvider {
    static var previews: some View {
        LongmanView(phrase: "test")
    }
}
