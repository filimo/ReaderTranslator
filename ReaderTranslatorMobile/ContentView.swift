//
//  ContentView.swift
//  ReaderTranslatorMobile
//
//  Created by Viktor Kushnerov on 28/2/20.
//  Copyright © 2020 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isShow = false
    
    init() {
        ViewsStore.shared.enabledViews = [.gTranslator, .web]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GTranslatorView(), isActive: $isShow) { EmptyView() }
                WebView()
            }
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
