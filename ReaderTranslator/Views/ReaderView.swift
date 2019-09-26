//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

//protocol StoreDelegate {
//    var store: Store { get }
//}
//
//extension StoreDelegate {
//    var store: EnvironmentObject<Store> {
//        get {
//            var env = EnvironmentObject<Store>(wrappedValue: Store.shared)
//            return env
//        }
//    }
//}

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
    @ObservedObject var store = Store.shared

    var body: some View {
        return Group {
            if store.viewMode == .web {
                VStack {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left\(store.canGoBack ? ".fill" : "")")
                            .onTapGesture {
                                _ = WebView.pageView.goBack()
                            }
                        TextField("Enter website name", text: self.$store.lastWebPage)
                        Image(systemName: "xmark.circle")
                        .onTapGesture {
                            _ = self.store.lastWebPage = ""
                        }
                    }.padding(5)
                    if self.store.currentTab == 0 { WebView(lastWebPage: $store.lastWebPage) }
                    if self.store.currentTab == 1 { WebView(lastWebPage: $store.lastWebPage) }
                    if self.store.currentTab == 2 { WebView(lastWebPage: $store.lastWebPage) }
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
