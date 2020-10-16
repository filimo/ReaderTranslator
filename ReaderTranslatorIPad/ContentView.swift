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

    @State var service: AvailableView = .gTranslator {
        didSet {
            enbaledService(service)
        }
    }

    init() {
        ViewsStore.shared.enabledViews = [.gTranslator, .web]
    }

    var body: some View {
        if case let .speak(text) = self.store.translateAction {
            store.translateAction.next()
            SpeechSynthesizer.speak(text: text, enabledSpeakByEngine: false)
        }

        return HStack {
            VStack {
                Menu("TranslateBy") {
                    Button("Google Translate", action: {
                        service = .gTranslator
                    })
                    Button("ReversoContext", action: {
                        service = .reverso
                    })
                    Button("Longman", action: {
                        service = .longman
                    })
                    Button("Cancel", action: {})
                }

                switch service {
                case .gTranslator: GTranslatorView()
                case .reverso: ReversoView()
                case .longman: LongmanView()
                default: EmptyView()
                }
            }
            .frame(width: 400)

            WebView()
        }
    }

    private func enbaledService(_ service: AvailableView) {
        ViewsStore.shared.enabledViews.remove(.gTranslator)
        ViewsStore.shared.enabledViews.remove(.reverso)
        ViewsStore.shared.enabledViews.remove(.longman)

        ViewsStore.shared.enabledViews.insert(service)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 2388 / 3.0, height: 1668 / 3.0))
    }
}
