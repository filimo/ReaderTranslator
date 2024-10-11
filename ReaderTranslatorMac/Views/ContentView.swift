//
//  ContentView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/15/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewStore = ViewsStore.shared

    init() {
        #if os(macOS)
            NSApplication.shared.servicesProvider = ServiceProvider()
            NSUpdateDynamicServices()
        #endif
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ReaderView()
                    .blur(radius: viewStore.showSettings ? 1 : 0)

                StatusBarView()
            }

            SettingsView()
        }
    }
}
