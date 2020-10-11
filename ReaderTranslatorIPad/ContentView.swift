//
//  ContentView.swift
//  ReaderTranslatorIPad
//
//  Created by Viktor Kushnerov on 19.04.2020.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var store = Store.shared

    init() {
        ViewsStore.shared.enabledViews = [.gTranslator, .web]
    }

    var body: some View {
        if case let .speak(text) = self.store.translateAction {
            store.translateAction.next()
            SpeechSynthesizer.speak(text: text, enabledSpeakByEngine: false)
        }

        return HStack {
            HStack {
                GTranslatorView()
                    .frame(width: 400)

                WebView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 2388 / 3.0, height: 1668 / 3.0))
    }
}
