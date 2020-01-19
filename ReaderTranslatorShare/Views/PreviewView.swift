//
//  PreviewView.swift
//  ReaderTranslatorShare
//
//  Created by Viktor Kushnerov on 19/1/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct PreviewView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        Group {
            VStack {
                HStack {
                    Button(
                        action: { self.store.viewMode = .gTranslator },
                        label: { Text("GTranslate") }).buttonStyle(RoundButtonStyle()
                    )
                    Button(
                        action: { self.store.viewMode = .longman },
                        label: { Text("Longman") }).buttonStyle(RoundButtonStyle()
                    )
                }
                ZStack {
                    GTranslatorRepresenter(sentence: store.sentence)
                    LongmanRepresenter(phrase: store.sentence)
                        .offset(x: store.viewMode == .longman ? 0 : UIScreen.main.bounds.width)
                }
            }
            .padding(.top)
            .animation(.linear(duration: 0.1))
        }
    }
}
