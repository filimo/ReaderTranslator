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

    @State var showHosts = false

    private var playerControlHeight = UIScreen.main.bounds.height / 4

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                WKWebRepresenter().frame(height: playerControlHeight * 2)
            }
            PlayerControlsView().frame(height: playerControlHeight)
            FileListView().frame(height: playerControlHeight)
            Image(systemName: "wifi")
            .onTapGesture {
                self.showHosts = true
            }
        }
        .sheet(isPresented: $showHosts) { HostsView() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
