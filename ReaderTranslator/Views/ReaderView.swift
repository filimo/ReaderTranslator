//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        HStack {
            if store.viewMode == .web {
                VStack {
                    TextField("Enter website name", text: $store.lastWebPage)
                    WebView(url: $store.lastWebPage)
                }
            }
            if store.viewMode == .pdf {
                PDFKitView()
            }
            TranslatorView(text: .constant(URLQueryItem(name: "text", value: store.selectedText)))
        }
        .onAppear {
            _ = self.store.$selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    if(self.store.isVoiceEnabled && text != "") {
                        SpeechSynthesizer.speech(text: text, voiceName: self.store.voiceName)
                    }
            }
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView()
    }
}
