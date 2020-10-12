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
                    label: {
                        Image(systemName: "chevron.left")
                            .styleButton()
                    }
                )

                Button(
                    action: {
                        WKRepresenter.currentWebView?.historyForward()
                    },
                    label: {
                        Image(systemName: "chevron.right")
                            .styleButton()
                    }
                )

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
                    label: {
                        Image(systemName: "doc.on.clipboard")
                            .styleButton()
                    }
                )
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .foregroundColor(.primary)
            .background(Color.secondary)

            WKRepresenter(lastWebPage: $webStore.lastWebPage)
        }
        .onAppear { url = webStore.lastWebPage }
    }
}

extension Image {
    fileprivate func styleButton() -> some View {
        resizable()
        .scaledToFit()
        .frame(width: 10, height: 15)
        .padding(5)
        .border(Color.black)

    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}
