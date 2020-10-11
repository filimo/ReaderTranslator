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
                Button(
                    action: {
                        WKRepresenter.currentWebView?.historyBack()
                    },
                    label: { Image(systemName: "chevron.left") }
                )
                .padding(5)
                .border(Color.black)

                Button(
                    action: {
                        WKRepresenter.currentWebView?.historyForward()
                    },
                    label: { Image(systemName: "chevron.right") }
                )
                .padding(5)
                .border(Color.black)

                TextField(
                    "URL",
                    text: $url,
                    onCommit: { webStore.lastWebPage = url }
                )


                Button(
                    action: {
                        url = Clipboard.string
                        webStore.lastWebPage = url
                    },
                    label: { Image(systemName: "doc.on.clipboard") }
                )
                .padding(5)
                .border(Color.black)
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Color.secondary)
            .foregroundColor(.primary)

            WKRepresenter(lastWebPage: $webStore.lastWebPage)
        }
        .onAppear { url = webStore.lastWebPage }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
