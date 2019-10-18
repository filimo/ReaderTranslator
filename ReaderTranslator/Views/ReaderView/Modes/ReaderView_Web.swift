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

    var body: some View {
        Group {
            if store.viewMode == .web {
                VStack {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left\(store.canGoBack ? ".fill" : "")")
                            .onTapGesture { WKRepresenter.pageView.goBack() }
                        TextField("Enter website name", text: self.$store.lastWebPage)
                        openInSafari()
                        pasteClipbord()
                        Button(action: { self.store.lastWebPage = "" }) {
                            Image(systemName: "xmark.circle")
                        }
                    }.padding(5)
                    webView(0)
                    webView(1)
                    webView(2)
                }
            }
        }
    }
}
 
extension ReaderView_Web {
    private func webView(_ currentTab: Int) -> some View {
        if self.store.currentTab == currentTab {
            let view = WKRepresenter(lastWebPage: $store.lastWebPage)
            return view.any
        }else{
            return EmptyView().any
        }
    }
    
    fileprivate func openInSafari() -> Button<Image> {
        Button(action: {
            if let url = URL(string: self.store.lastWebPage) {
                Safari.openSafari(url)
            }
        }) { Image(systemName: "safari") }
    }
    
    fileprivate func pasteClipbord() -> Button<Image> {
        Button(action: {
            self.store.lastWebPage = Clipboard.string
        }) { Image(systemName: "doc.on.clipboard") }
    }
}

struct ReaderView_Web_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Web().environmentObject(Store.shared)
    }
}
