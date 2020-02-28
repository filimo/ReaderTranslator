//
//  WebView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct WebView: View {
    @ObservedObject var webStore = WebStore.shared
    @State var url: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField(
                    "URL",
                    text: $url,
                    onCommit: { self.webStore.lastWebPage = self.url })
                Button(action: {
                    self.url = Clipboard.string
                    self.webStore.lastWebPage = self.url
                }, label: { Image(systemName: "doc.on.clipboard") })
            }
            .padding([.leading, .trailing], 5)
            WKRepresenter(lastWebPage: $webStore.lastWebPage)
        }
        .onAppear { self.url = self.webStore.lastWebPage }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
