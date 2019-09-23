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
        HStack {
            ReaderView_Web()
            ReaderView_PDF()
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

struct ReaderView_Web: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        return Group {
            if store.viewMode == .web {
                VStack {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left\(store.canGoBack ? ".fill" : "")")
                            .onTapGesture {
                                _ = PageWebView.shared.goBack()
                            }
                        TextField("Enter website name", text: self.$store.lastWebPage)
                    }.padding(5)
                    WebView(lastWebPage: self.$store.lastWebPage, zoom: self.$store.zoom)
                }
            }else{
                EmptyView()
            }
        }
    }
}

struct ReaderView_PDF: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Group {
            if store.viewMode == .pdf {
                if store.viewMode == .pdf {
                    PDFKitView()
                }
            }else{
                EmptyView()
            }
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView()
    }
}
