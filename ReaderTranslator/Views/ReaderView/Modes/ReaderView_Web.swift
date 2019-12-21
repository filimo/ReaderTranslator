//
//  ReaderView_Web.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Web: View {
    @ObservedObject private var store = Store.shared
    @ObservedObject var viewsStore = ViewsStore.shared

    var body: some View {
        VStack {
            if viewsStore.enabledViews.contains(.web) {
                VStack {
                    HStack {
                        Image.sfSymbol("arrowshape.turn.up.left\(store.canGoBack ? ".fill" : "")")
                            .onTapGesture { WKRepresenter.pageView.goBack() }
                        TextField("Enter website name", text: self.$store.lastWebPage)
                        openInSafari()
                        pasteClipbord()
                        Button(
                            action: { self.store.lastWebPage = "" },
                            label: { Image.sfSymbol("xmark.circle") }
                        )
                    }.padding(5)
                    webView(0)
                    webView(1)
                    webView(2)
                }
                tabsView
            }
        }
    }

    var tabsView: some View {
        HStack {
            Button(
                action: { self.store.currentTab = 0 },
                label: { Image.sfSymbol("1.circle\(iconStatus(0))") }
            )
            Button(
                action: { self.store.currentTab = 1 },
                label: { Image.sfSymbol("2.circle\(iconStatus(1))") }
            )
            Button(
                action: { self.store.currentTab = 2 },
                label: { Image.sfSymbol("3.circle\(iconStatus(2))") }
            )
        }
    }

    private func iconStatus(_ tab: Int) -> String {
        store.currentTab == tab ? ".fill" : ""
    }
}

extension ReaderView_Web {
    private func webView(_ currentTab: Int) -> some View {
        if store.currentTab == currentTab {
            let view = WKRepresenter(lastWebPage: $store.lastWebPage)
            return view.any
        } else {
            return EmptyView().any
        }
    }

    fileprivate func openInSafari() -> some View {
        Button(
            action: {
                if let url = URL(string: self.store.lastWebPage) {
                    Safari.openSafari(url)
                }
            },
            label: { Image.sfSymbol("safari") }
        )
    }

    fileprivate func pasteClipbord() -> some View {
        Button(
            action: {
                self.store.lastWebPage = Clipboard.string
            },
            label: { Image.sfSymbol("doc.on.clipboard") }
        )
    }
}

struct ReaderView_Web_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Web()
    }
}
