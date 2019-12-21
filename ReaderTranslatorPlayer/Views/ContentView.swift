//
//  ContentView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 29/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FileListView()
                PlayerControlsView()
                BookmarksView()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(store.hideNavBar)
            .onAppear { self.store.hideNavBar = true }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject var store = Store.shared

    static var previews: some View {
        ContentView()
    }
}
