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
            VStack {
                NavigationLink(
                    destination: GTranslatorView(),
                    isActive: $isShow
                ) {
                    EmptyView()
                }
                WebView()
                if !isShow { GTranslatorMiniView().frame(height: 200) }
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
