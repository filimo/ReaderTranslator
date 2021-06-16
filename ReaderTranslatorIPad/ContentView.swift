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
                    Button("Google Translate") { service = .gTranslator }
                    Button("DeepL") { service = .deepL }
                    Button("ReversoContext") { service = .reverso }
                    Button("Longman") { service = .longman }
                    Button("Collins") { service = .collins }
                    Button("Cambridge") { service = .cambridge }
                    Button("Wiki") { service = .wikipedia }
                    
                    Divider()

                    Button("Cancel") {}
                }

                ZStack {
                    GTranslatorView().opacity(service == .gTranslator ? 1 : 0)
                    DeepLView().opacity(service == .deepL ? 1 : 0)
                    ReversoView().opacity(service == .reverso ? 1 : 0)
                    LongmanView().opacity(service == .longman ? 1 : 0)
                    CollinsView().opacity(service == .collins ? 1 : 0)
                    CambidgeView().opacity(service == .cambridge ? 1 : 0)
                    WikipediaView().opacity(service == .wikipedia ? 1 : 0)
                }
            }
            .frame(width: 470)

            WebView()
        }
    }

    private func enbaledService(_ service: AvailableView) {
        ViewsStore.shared.enabledViews = [.web]

        ViewsStore.shared.enabledViews.insert(service)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 2388 / 3.0, height: 1668 / 3.0))
    }
}
