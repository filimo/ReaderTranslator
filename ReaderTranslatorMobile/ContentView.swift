//
//  ContentView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct ContentView: View {
    @State var isShow = false

    init() {
        ViewsStore.shared.enabledViews = [.gTranslator, .web]
    }

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: GTranslatorView(),
                    isActive: $isShow
                ) {
                    EmptyView()
                }
                
                WebView()
                
                BottomSheetView(isOpen: .constant(false), maxHeight: 600) {
                    if !isShow { GTranslatorMiniView() }
                }.edgesIgnoringSafeArea(.all)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("ReaderTranslator", displayMode: .inline)
            .navigationBarItems(trailing: Button("Translate") { self.isShow = true })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
