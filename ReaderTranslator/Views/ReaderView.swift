//
//  ReaderView.swift
//  PdfTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView: View {
    @Binding var url: String

    @EnvironmentObject var store: Store

    @UserDefault(key: "LAST_URL", defaultValue: "https://www.google.com")
    private var lastURL: String

    var body: some View {
        HStack {
            if store.mode == .web {
                VStack {
                    TextField("Enter website name", text: $url, onEditingChanged: { event in
                        self.lastURL = self.url
                    })
                    WebView(url: $url)
                }
            }
            if store.mode == .pdf {
                PDFKitView()
            }
            TranslatorView(text: .constant(URLQueryItem(name: "text", value: store.selectedText)))
        }
        .onAppear {
            self.url = self.lastURL
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(url: .constant(""))
    }
}
