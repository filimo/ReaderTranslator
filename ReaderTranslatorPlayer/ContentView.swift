//
//  ContentView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 29/11/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private var networkManager = NetworkManager()

    @ObservedObject var store = Store.shared
    private var playerControlHeight = UIScreen.main.bounds.height / 4

    init() {
        sharedBrowser = PeerBrowser(delegate: networkManager)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                WKWebRepresenter().frame(height: playerControlHeight * 2)
            }
            PlayerControlsView().frame(height: playerControlHeight)
            FileListView().frame(height: playerControlHeight)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
