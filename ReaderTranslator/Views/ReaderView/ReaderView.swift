//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct ReaderView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        Stack(arrange: store.viewMode == .safari ? .vertical : .horizontal) {
            ReaderView_PDF()
            ReaderView_Web() 
            ReaderView_Safari()
            TranslatorView(text: .constant(URLQueryItem(name: "text", value: self.store.selectedText)))
        }
        .onAppear {
            _ = self.store.$selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    SpeechSynthesizer.speak(text: text, voiceName: self.store.voiceName)
                }
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView().environmentObject(Store.shared)
    }
}
